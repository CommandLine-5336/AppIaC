output "id" {
  description = "VPC id"
  value       = aws_vpc.main.id
}

output "vpc_cidr" {
  description = "VPC cidr"
  value       = aws_vpc.main.cidr_block
}

output "public_subnets" {
  description = "VPC public subnets"
  value       = aws_subnet.public_subnet[*].id
}

output "private_subnets" {
  description = "VPC ptivate subnets"
  value       = aws_subnet.private_subnet[*].id
}
