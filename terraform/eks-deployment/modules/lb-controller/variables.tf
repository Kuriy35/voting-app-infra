variable "cluster_name" {
  description = "Name of EKS cluster"
  type        = string
}

variable "vpc_id" {
  description = "VPC ID"
  type        = string
}

variable "lb_controller_role_arn" {
  description = "ARN of IRSA for load balancer controller"
  type        = string
}
