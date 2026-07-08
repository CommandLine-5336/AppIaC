data "aws_caller_identity" "current" {}
data "aws_region" "current" {}

module "images_bucket" {
  source = "../modules/bucket"

  name            = "images"
  env             = var.environment
  caller_identity = var.caller_id
  region          = var.region
}

module "security_scan_bucket" {
  source = "../modules/bucket"

  name            = "security-scan"
  env             = var.environment
  caller_identity = var.caller_id
  region          = var.region
}

module "jenkins_bucket" {
  source = "../modules/bucket"

  name            = "jenkins"
  env             = var.environment
  caller_identity = var.caller_id
  region          = var.region
}