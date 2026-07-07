data "aws_caller_identity" "current" {}
data "aws_region" "current" {}


module "terraform_state_bucket" {
  source = "../modules/bucket"

  name            = "terraform-state"
  env             = "Dev"
  caller_identity = data.aws_caller_identity.current.account_id
  region          = data.aws_region.current.name
}