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
