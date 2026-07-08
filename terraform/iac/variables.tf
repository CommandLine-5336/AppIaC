variable "access_key_id" {
  type = string
}
variable "secret_access_key" {
  type = string
}

variable "environment" {
  type        = string
  default     = "dev"
}

variable "region" {
  type        = string
  default     = "us-east-1"
}

variable "caller_id" {
  type        = string
}
