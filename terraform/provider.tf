variable "access_key_id" {
  type = string
}
variable "secret_access_key" {
  type = string
}

terraform {
  required_version = "1.9.5"
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "6.52.0"
    }
  }
}

provider "aws" {
  region     = "us-east-1"
  access_key = var.access_key_id
  secret_key = var.secret_access_key
}
