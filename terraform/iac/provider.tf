terraform {
  required_version = "1.15.7"
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "6.52.0"
    }
  }
}

provider "aws" {
  region     = var.region
  access_key = var.access_key_id
  secret_key = var.secret_access_key
}
