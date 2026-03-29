variable "aws_region" {
  description = "AWS Region for resources"
  type        = string
}

variable "env" {
  description = "Current environment"
  type        = string
}

variable "vpc_cidr" {
  description = "CIDR block for VPC"
  type        = string
}

variable "project_id" {
  description = "Project ID"
  type        = string
}
