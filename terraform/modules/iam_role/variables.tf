variable "name" {
  description = "Name of the IAM role"
  type        = string
}

variable "trusted_services" {
  description = "List of AWS service principals that can assume this role"
  type        = list(string)
  default     = []
}

variable "managed_policy_arns" {
  description = "List of managed IAM policy ARNs to attach"
  type        = list(string)
  default     = []
}

variable "inline_policies" {
  description = "Map of inline policy names to JSON policy documents"
  type        = map(string)
  default     = {}
}

variable "create_instance_profile" {
  description = "Whether to create an EC2 instance profile for this role"
  type        = bool
  default     = true
}

variable "tags" {
  type    = map(string)
  default = {}
}