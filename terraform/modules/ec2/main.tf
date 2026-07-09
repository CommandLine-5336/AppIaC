terraform {
  required_version = "1.15.7"
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "6.52.0"
    }
  }
}

resource "aws_instance" "this" {
  ami                         = var.ami
  instance_type               = var.instance_type
  subnet_id                   = var.subnet_id
  associate_public_ip_address = var.assoc_pub_ip
  private_ip                  = var.assoc_pub_ip ? var.pub_ip : null

  vpc_security_group_ids = var.sg_id
  iam_instance_profile   = var.profile_name

  root_block_device {
    volume_size = var.volume_size
  }

  tags = {
    Name        = var.name
    Role        = var.role
    Environment = var.env
  }
}