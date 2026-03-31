variable "vpc_id" {
  description = "VPC ID to deploy resources in"
  type = string
}

variable "project_id" {
  description = "Project ID for resource naming"
  type = string
}

variable "env" {
  description = "Current environment"
  type = string
}

variable "public_subnet_cidr_blocks" {
  description = "CIDR blocks for public subnets"
  type = list(string)
}

variable "public_subnet_azs" {
  description = "Availability zones for public subnets"
  type = list(string)
}

variable "private_subnet_cidr_blocks" {
  description = "CIDR blocks for private subnets"
  type = list(string)
}

variable "private_subnet_azs" {
  description = "Availability zones for private subnets"
  type = list(string)
}