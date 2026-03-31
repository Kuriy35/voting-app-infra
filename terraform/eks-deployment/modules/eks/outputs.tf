output "cluster_name" {
  description = "Name of created EKS cluster"
  value       = aws_eks_cluster.cluster.name
}

output "cluster_endpoint" {
  description = "Endpoint of created EKS cluster"
  value       = aws_eks_cluster.cluster.endpoint
}

output "cluster_ca_certificate" {
  description = "Public CA certificate for the EKS cluster"
  value       = aws_eks_cluster.cluster.certificate_authority[0].data
  sensitive   = true
}

output "oidc_provider_arn" {
  description = "ARN of OIDC provider"
  value       = aws_iam_openid_connect_provider.eks.arn
}

output "oidc_issuer" {
  description = "OIDC issuer from EKS cluster"
  value       = aws_eks_cluster.cluster.identity[0].oidc[0].issuer
}
