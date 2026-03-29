variable "vpc_id" {
  description = "VPC ID"
  type        = string
}

variable "public_subnet_ids" {
  description = "List of public subnet ids"
  type        = list(string)
}

variable "private_subnet_ids" {
  description = "List of private subnet ids"
  type        = list(string)
}

variable "ami_id" {
  description = "AMI ID"
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

variable "postgres_engine_version" {
  description = "Postgresql db engine version"
  type        = string
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
