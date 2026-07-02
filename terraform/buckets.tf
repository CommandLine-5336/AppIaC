data "aws_caller_identity" "current" {}
data "aws_region" "current" {}

resource "aws_s3_bucket" "images_bucket" {
  bucket = format("images-bucket-%s-%s", data.aws_caller_identity.current.account_id, data.aws_region.current.region)
  tags = {
    Name = "Images bucket"
    Enviroment ="Dev"
    Owner = "CommandLine"
}
}

resource "aws_s3_bucket" "security_scan_bucket" {
  bucket = format("security-scan-bucket-%s-%s", data.aws_caller_identity.current.account_id, data.aws_region.current.region)
  tags = {
    Name = "Security scan"
    Enviroment ="Dev"
    Owner = "CommandLine"
}
}

resource "aws_s3_bucket" "terraform_state_bucket" {
  bucket = format("terraform-state-bucket-%s-%s", data.aws_caller_identity.current.account_id, data.aws_region.current.region)
  tags = {
    Name = "Terraform state"
    Enviroment ="Dev"
    Owner = "CommandLine"
}
}