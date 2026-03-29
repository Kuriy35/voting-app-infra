variable "aws_region" {
  description = "AWS region for resources"
  type        = string
}

variable "profile" {
  description = "AWS profile"
  type        = string
}

variable "env" {
  description = "Deployment environment"
  type        = string
}

variable "project_id" {
  description = "Project ID for resource naming"
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

variable "db_username" {
  description = "Master username for the RDS Postgres instance"
  type        = string
}

variable "db_name" {
  description = "Name for votes database"
  type        = string
}

variable "db_availability_zone" {
  description = "Availability zone for DB instance"
  type        = string
}

variable "public_key" {
  description = "Public SSH key"
  type        = string
}
