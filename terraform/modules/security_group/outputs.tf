output "id" {
  description = "ID of the security group"
  value       = aws_security_group.this.id
}

output "name" {
  description = "The name of the security group"
  value       = aws_security_group.this.name
}