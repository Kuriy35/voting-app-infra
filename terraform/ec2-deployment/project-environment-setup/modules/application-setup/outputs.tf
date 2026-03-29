output "vote_instance_public_ips" {
  description = "List of vote instance public ips"
  value       = [for i in aws_instance.vote : i.public_ip]
}

output "result_instance_public_ips" {
  description = "List of result instance public ips"
  value       = [for i in aws_instance.result : i.public_ip]
}
