data "aws_caller_identity" "current" {}
data "aws_region" "current" {}

module "images_bucket" {
  source = "../modules/bucket"

  name            = "images"
  env             = "Dev"
  caller_identity = data.aws_caller_identity.current.account_id
  region          = data.aws_region.current.region
}

module "security_scan_bucket" {
  source = "../modules/bucket"

  name            = "security-scan"
  env             = "Dev"
  caller_identity = data.aws_caller_identity.current.account_id
  region          = data.aws_region.current.region
}

module "jenkins_bucket" {
  source = "../modules/bucket"

  name            = "jenkins"
  env             = "Dev"
  caller_identity = data.aws_caller_identity.current.account_id
  region          = data.aws_region.current.region
}