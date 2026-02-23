resource "random_password" "db_password" {
  length           = 16
  special          = true
  override_special = "!#$%&*()-_=+[]{}<>:?"
}

resource "aws_ssm_parameter" "db_password_param" {
  name        = "/${var.env}/database/password"
  description = "Master Password for RDS Postgres database"
  type        = "SecureString"
  value       = random_password.db_password.result
}

resource "aws_db_subnet_group" "db_subnet_group" {
  name       = "${var.project_id}-${var.env}-db-subnet-group"
  subnet_ids = var.private_subnet_ids
}

resource "aws_db_instance" "postgres" {
  allocated_storage      = 20
  db_name                = var.db_name
  engine                 = "postgres"
  engine_version         = var.postgres_engine_version
  instance_class         = "db.t4g.micro"
  username               = var.db_username
  password               = random_password.db_password.result
  skip_final_snapshot    = true
  vpc_security_group_ids = [aws_security_group.db_sg.id]
  db_subnet_group_name   = aws_db_subnet_group.db_subnet_group.id
  multi_az               = false
  availability_zone      = var.db_availability_zone
}
