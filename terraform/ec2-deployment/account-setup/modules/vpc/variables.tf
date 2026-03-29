variable "project_id" {
  description = "Project ID for resource naming"
  type        = string
}

variable "vpc_cidr" {
  description = "Cidr block for VPC"
  type        = string
}

variable "env" {
  description = "Deployment environment"
  type        = string
}
