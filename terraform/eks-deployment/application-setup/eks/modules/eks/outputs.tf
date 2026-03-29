output "eks_cluster_name" {
  description = "Name of created EKS cluster"
  value       = aws_eks_cluster.cluster.name
}

output "oidc_provider_arn" {
  description = "ARN of OIDC provider"
  value       = aws_iam_openid_connect_provider.eks.arn
}

output "oidc_issuer" {
  description = "OIDC issuer from EKS cluster"
  value       = aws_eks_cluster.cluster.identity[0].oidc[0].issuer
}
