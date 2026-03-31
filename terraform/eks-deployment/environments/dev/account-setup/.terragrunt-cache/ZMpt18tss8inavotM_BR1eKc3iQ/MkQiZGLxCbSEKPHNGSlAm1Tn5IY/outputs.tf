output "vpc_id" {
  description = "ID of created VPC"
  value       = aws_vpc.vpc.id
}
