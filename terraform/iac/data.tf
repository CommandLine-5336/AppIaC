data "aws_ami" "packer_image" {
  most_recent = true
  owners      = ["self"]

  filter {
    name   = "name"
    values = ["packer-ubuntu-golden-image-*"]
  }
}

data "aws_ami" "packer_image_jenkins" {
  most_recent = true
  owners      = ["self"]

  filter {
    name   = "name"
    values = ["jenkins-ubuntu-golden-image-*"]
  }
}
