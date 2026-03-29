output "eks_cluster_name" {
  description = "Name of created EKS cluster"
  value       = module.eks.eks_cluster_name
}

output "oidc_provider_arn" {
  description = "ARN of OIDC provider"
  value       = module.eks.oidc_provider_arn
}

output "oidc_issuer" {
  description = "OIDC issuer from EKS cluster"
  value       = module.eks.oidc_issuer
}

output "public_subnet_ids" {
  description = "List of public subnet IDs"
  value       = module.network.public_subnet_ids
}
