variable "aws_region" {
  description = "AWS region for resources"
  type        = string
}

variable "profile" {
  description = "AWS account"
  type        = string
}

variable "env" {
  description = "Deployment environment"
  type        = string
}

variable "project_id" {
  description = "Project ID"
  type        = string
}

variable "vpc_cidr" {
  description = "Cidr block for VPC"
}
