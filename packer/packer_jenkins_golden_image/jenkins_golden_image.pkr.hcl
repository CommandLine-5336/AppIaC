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
  ami_name      = "jenkins-ubuntu-golden-image-{{timestamp}}"
  instance_type = "t3.small"
  region        = "us-east-1"
  source_ami_filter {
    filters = {
      name                = "packer-ubuntu-golden-image-1782997115"
      root-device-type    = "ebs"
      virtualization-type = "hvm"
    }
    most_recent = true
    owners      = ["704427427594"]
  }
  ssh_username = "ubuntu"
  temporary_iam_instance_profile_policy_document {
    Version = "2012-10-17"
    Statement {
      Effect   = "Allow"
      Action   = ["s3:PutObject"]
      Resource = ["arn:aws:s3:::security-scan-bucket-704427427594-us-east-1/*"]
    }
    Statement {
      Effect = "Allow"
      Action = [
        "secretsmanager:GetSecretValue",
        "secretsmanager:DescribeSecret"
      ]
      Resource = ["arn:aws:secretsmanager:*:*:secret:*"]
    }
    Statement {
      Effect = "Allow"
      Action = [
        "secretsmanager:BatchGetSecretValue",
        "secretsmanager:ListSecrets"
      ]
      Resource = ["*"]
    }
    Statement {
      Effect   = "Allow"
      Action   = ["kms:Decrypt"]
      Resource = ["arn:aws:kms:*:*:key/*"]
    }
  }
}

build {
  sources = ["source.amazon-ebs.ubuntu-golden-image"]
  provisioner "ansible" {
    playbook_file = "./jenkins_install.yaml"
    galaxy_file   = "./requirements.yaml"
  }
}
