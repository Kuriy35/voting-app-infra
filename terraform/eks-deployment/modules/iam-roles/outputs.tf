output "lb_controller_role_arn" {
  description = "ARN of IRSA for load balancer controller"
  value       = aws_iam_role.lb_controller.arn
}

output "external_secrets_operator_role_arn" {
  description = "ARN of IRSA for external secrets operator"
  value       = aws_iam_role.external_secrets_operator.arn
}

output "duckdns_token_secret_name" {
  description = "Name of duckdns token secret"
  value       = aws_secretsmanager_secret.duckdns_token.name
}

output "add_value_to_created_secret" {
  description = "Command that you need to use, to add value to secret"
  value       = "aws secretsmanager put-secret-value --region us-east-1 --secret-id $(terragrunt output -raw duckdns_secret_name) --secret-string PUT_TOKEN_HERE"
}
