data "aws_vpc" "vpc" {
  tags = {
    Name = "${var.project_id}-${var.env}-vpc"
  }
}

data "aws_ami" "latest_amazon_linux" {
  most_recent = true
  owners      = ["amazon"]

  filter {
    name   = "name"
    values = ["al2023*"]
  }

  filter {
    name   = "architecture"
    values = ["x86_64"]
  }
}

data "aws_rds_engine_version" "postgres_engine_version" {
  engine = "postgres"
}
