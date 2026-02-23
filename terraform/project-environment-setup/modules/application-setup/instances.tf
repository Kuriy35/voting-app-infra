resource "aws_key_pair" "key_pair" {
  key_name   = "${var.project_id}-${var.env}-keypair"
  public_key = var.public_key
}

resource "aws_instance" "vote" {
  count = 1

  ami                    = var.ami_id
  instance_type          = "t3.micro"
  key_name               = aws_key_pair.key_pair.key_name
  subnet_id              = element(var.public_subnet_ids, count.index)
  vpc_security_group_ids = [aws_security_group.vote_sg.id]
  user_data = templatefile("${path.module}/scripts/vote_user_data.sh", {
    redis_private_ip = aws_instance.redis.private_ip
  })

  tags = {
    Name = "${var.project_id}-${var.env}-vote"
  }
}

resource "aws_instance" "redis" {
  ami                    = var.ami_id
  instance_type          = "t3.micro"
  key_name               = aws_key_pair.key_pair.key_name
  subnet_id              = var.private_subnet_ids[0]
  vpc_security_group_ids = [aws_security_group.redis_sg.id]
  user_data              = file("${path.module}/scripts/redis_user_data.sh")

  tags = {
    Name = "${var.project_id}-${var.env}-redis"
  }
}

resource "aws_instance" "worker" {
  ami                    = var.ami_id
  instance_type          = "t3.micro"
  key_name               = aws_key_pair.key_pair.key_name
  subnet_id              = var.private_subnet_ids[0]
  vpc_security_group_ids = [aws_security_group.worker_sg.id]
  user_data = templatefile("${path.module}/scripts/worker_user_data.sh", {
    redis_private_ip = aws_instance.redis.private_ip,
    db_hostname      = aws_db_instance.postgres.address,
    db_username      = var.db_username,
    db_password      = random_password.db_password.result,
    db_name          = var.db_name
  })

  root_block_device {
    volume_size = 8
    volume_type = "gp3"
  }

  tags = {
    Name = "${var.project_id}-${var.env}-worker"
  }
}

resource "aws_instance" "result" {
  count = 1

  ami                    = var.ami_id
  instance_type          = "t3.micro"
  key_name               = aws_key_pair.key_pair.key_name
  subnet_id              = element(var.public_subnet_ids, count.index)
  vpc_security_group_ids = [aws_security_group.result_sg.id]
  user_data = templatefile("${path.module}/scripts/result_user_data.sh", {
    db_hostname = aws_db_instance.postgres.address,
    db_username = var.db_username,
    db_password = random_password.db_password.result,
    db_name     = var.db_name
  })

  tags = {
    Name = "${var.project_id}-${var.env}-result"
  }
}
