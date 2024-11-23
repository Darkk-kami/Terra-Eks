output "vpc" {
  value = aws_vpc.vpc.id
}

output "private_subnets" {
  description = "List of private subnet IDs"
  value       = aws_subnet.private_subnets
}

output "public_subnets" {
  description = "List of public subnet IDs"
  value       = aws_subnet.public_subnets
}

# Output the ID of the S3 VPC endpoint
output "vpc_endpoint" {
  value = aws_vpc_endpoint.s3_endpoint.id
}