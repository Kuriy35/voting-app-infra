variable "aws_region" {
  description = "AWS region for resources"
  type        = string
}

variable "env" {
  description = "Current environment"
  type        = string
}

variable "project_id" {
  description = "Project ID for resource naming"
  type        = string
}

variable "git_repo_url" {
  description = "Voting app helm chart git repository URL"
  type        = string
}
