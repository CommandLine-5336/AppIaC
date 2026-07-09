output "role_name" {
  description = "Name of the IAM role"
  value       = aws_iam_role.this.name
}

output "role_id" {
  description = "Unique ID of the IAM role"
  value       = aws_iam_role.this.unique_id
}

output "instance_profile_name" {
  description = "Name of the instance profile (if created)"
  value       = var.create_instance_profile ? aws_iam_instance_profile.this[0].name : null
}