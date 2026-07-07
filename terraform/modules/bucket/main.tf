resource "aws_s3_bucket" "this" {
  bucket = format("%s-bucket-%s-%s", var.name, var.caller_identity, var.region)
  tags = {
    Name        = "${var.name}"
    Environment = "${var.env}"
    Owner       = "CommandLine"
  }
  lifecycle {
    prevent_destroy = true
  }
}