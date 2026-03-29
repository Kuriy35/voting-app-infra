variable "public_subnet_ids" {
  description = "List of public subnet IDs"
  type        = list(string)
}

variable "private_subnet_ids" {
  description = "List of private subnet IDs"
  type        = list(string)
}

variable "project_id" {
  description = "Project ID for resource naming"
  type        = string
}

variable "env" {
  description = "Current environment"
  type        = string
}

variable "cluster_version" {
  description = "Desired version of EKS cluster"
  type        = string
}

variable "instance_types" {
  description = "Instance types for Node Group"
  type        = list(string)
}
