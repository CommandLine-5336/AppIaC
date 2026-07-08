terraform {
  backend "s3" {
    bucket = "terraform-state-bucket-dev-704427427594-us-east-1"
    key    = "states/terraform.tfstate"
    region = "us-east-1"
  }
}
