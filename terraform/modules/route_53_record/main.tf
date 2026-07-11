terraform {
  required_version = "1.15.7"
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "6.52.0"
    }
  }
}

resource "aws_route53_record" "this" {
  zone_id = var.zone_id
  name    = var.domain_name
  type    = var.type
  ttl     = var.ttl
  records = var.records
}