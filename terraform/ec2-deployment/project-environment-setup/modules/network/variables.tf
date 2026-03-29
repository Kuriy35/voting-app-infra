variable "vpc_id" {
  description = "VPC ID"
  type        = string
}

variable "availability_zones" {
  description = "List of AZs"
  type        = list(string)
}

variable "public_cidr_blocks" {
  description = "List of Cidr blocks for public subnets"
  type        = list(string)
}

variable "private_cidr_blocks" {
  description = "List of Cidr blocks for private subnets"
  type        = list(string)
}

variable "env" {
  description = "Deployment environment"
  type        = string
}

variable "project_id" {
  description = "Project ID for resource naming"
  type        = string
}
