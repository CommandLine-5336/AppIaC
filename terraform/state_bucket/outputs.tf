output "tf_state_bucket_name" {
  description = "Name of the bucket for tf state"
  value       = module.terraform_state_bucket.bucket_id
}