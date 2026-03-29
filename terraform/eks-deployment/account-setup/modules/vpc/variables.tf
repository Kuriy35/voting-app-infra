variable "project_id" {
  description = "Project ID for resource naming"
  type = string
}

variable "vpc_cidr" {
  description = "CIDR block for VPC"
  type = string
}

variable "env" {
  description = "Current environment"
  type = string
}