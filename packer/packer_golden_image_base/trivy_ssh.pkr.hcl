packer {
  required_plugins {
    ansible = {
      version = "1.1.5"
      source  = "github.com/hashicorp/ansible"
    }
    amazon = {
      version = "1.2.8"
      source  = "github.com/hashicorp/amazon"
    }
  }
}
source "amazon-ebs" "ubuntu-golden-image" {
  ami_name      = "packer-ubuntu-golden-image-{{timestamp}}"
  instance_type = "t3.small"
  region        = "us-east-1"
  source_ami_filter {
    filters = {
      name                = "ubuntu/images/hvm-ssd-gp3/ubuntu-resolute-26.04-amd64-server-20260604"
      root-device-type    = "ebs"
      virtualization-type = "hvm"
    }
    most_recent = true
    owners      = ["099720109477"]
  }
  ssh_username = "ubuntu"
  temporary_iam_instance_profile_policy_document {
    Version = "2012-10-17"
    Statement {
      Effect   = "Allow"
      Action   = ["s3:PutObject"]
      Resource = ["arn:aws:s3:::security-scan-bucket-704427427594-us-east-1/*"]
    }
  }
}

build {
  sources = ["source.amazon-ebs.ubuntu-golden-image"]
  provisioner "ansible" {
    playbook_file   = "./packer_playbook.yaml"
    galaxy_file     = "./requirements.yaml"
  }
}
