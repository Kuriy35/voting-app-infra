variable "project_id" {
  description = "Project ID for resource naming"
  type        = string
}

variable "env" {
  description = "Current environment"
  type        = string
}

variable "git_repo_url" {
  description = "Git repository URL from which application will be deployed"
  type        = string
}

variable "public_subnet_ids" {
  description = "List of public subnet IDs"
  type        = list(string)
}

variable "vpc_id" {
  description = "VPC ID for resources deployment"
  type        = string
}

variable "cluster_name" {
  description = "Name of EKS cluster"
  type        = string
}

variable "external_secrets_operator_role_arn" {
  description = "IRSA ARN for external secret operator"
  type        = string
}

variable "duckdns_token_secret_name" {
  description = "Name of duckdns token secret"
  type        = string
}
