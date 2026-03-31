variable "project_id" {
  description = "Project ID for resource naming"
  type        = string
}

variable "env" {
  description = "Current environment"
  type        = string
}

variable "cluster_name" {
  description = "Name of EKS cluster"
  type        = string
}

variable "oidc_provider_arn" {
  description = "ARN of OIDC provider from EKS cluster"
  type        = string
}

variable "oidc_issuer" {
  description = "OIDC issuer"
  type        = string
}

variable "vpc_id" {
  description = "VPC ID"
  type        = string
}
