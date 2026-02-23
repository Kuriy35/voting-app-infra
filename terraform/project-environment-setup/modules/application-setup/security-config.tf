resource "aws_security_group" "vote_sg" {
  name        = "${var.project_id}-${var.env}-vote-sg"
  description = "SG for Vote instance"
  vpc_id      = var.vpc_id

  tags = {
    Name = "${var.project_id}-${var.env}-vote-sg"
  }
}

resource "aws_security_group" "result_sg" {
  name        = "${var.project_id}-${var.env}-result-sg"
  description = "SG for Result instance"
  vpc_id      = var.vpc_id

  tags = {
    Name = "${var.project_id}-${var.env}-result-sg"
  }
}

resource "aws_vpc_security_group_ingress_rule" "allow_inbound_http" {
  for_each = {
    vote   = aws_security_group.vote_sg.id
    result = aws_security_group.result_sg.id
  }

  security_group_id = each.value
  from_port         = 80
  to_port           = 80
  ip_protocol       = "tcp"
  cidr_ipv4         = "0.0.0.0/0"
}

resource "aws_security_group" "worker_sg" {
  name        = "${var.project_id}-${var.env}-worker-sg"
  description = "SG for Worker instance"
  vpc_id      = var.vpc_id

  tags = {
    Name = "${var.project_id}-${var.env}-worker-sg"
  }
}

resource "aws_security_group" "redis_sg" {
  name        = "${var.project_id}-${var.env}-redis-sg"
  description = "SG for Redis instance"
  vpc_id      = var.vpc_id

  tags = {
    Name = "${var.project_id}-${var.env}-redis-sg"
  }
}

resource "aws_vpc_security_group_ingress_rule" "redis_allow_inbound_traffic" {
  for_each = {
    vote   = aws_security_group.vote_sg.id
    worker = aws_security_group.worker_sg.id
  }

  security_group_id            = aws_security_group.redis_sg.id
  from_port                    = 6379
  to_port                      = 6379
  ip_protocol                  = "tcp"
  referenced_security_group_id = each.value
}

resource "aws_security_group" "db_sg" {
  name        = "${var.project_id}-${var.env}-db-sg"
  description = "SG for RDS DB instance"
  vpc_id      = var.vpc_id

  tags = {
    Name = "${var.project_id}-${var.env}-db-sg"
  }
}

resource "aws_vpc_security_group_ingress_rule" "db_allow_inbound_traffic" {
  for_each = {
    worker = aws_security_group.worker_sg.id
    result = aws_security_group.result_sg.id
  }

  security_group_id            = aws_security_group.db_sg.id
  from_port                    = 5432
  to_port                      = 5432
  ip_protocol                  = "tcp"
  referenced_security_group_id = each.value
}

resource "aws_vpc_security_group_ingress_rule" "allow_ssh" {
  for_each = {
    vote   = aws_security_group.vote_sg.id
    result = aws_security_group.result_sg.id
    worker = aws_security_group.worker_sg.id
    redis  = aws_security_group.redis_sg.id
  }

  security_group_id = each.value
  from_port         = 22
  to_port           = 22
  ip_protocol       = "tcp"
  cidr_ipv4         = "0.0.0.0/0"
}

resource "aws_vpc_security_group_egress_rule" "allow_all_outbound_ipv4" {
  for_each = {
    vote   = aws_security_group.vote_sg.id
    result = aws_security_group.result_sg.id
    worker = aws_security_group.worker_sg.id
    redis  = aws_security_group.redis_sg.id
    db     = aws_security_group.db_sg.id
  }

  security_group_id = each.value
  ip_protocol       = "-1"
  cidr_ipv4         = "0.0.0.0/0"
}
