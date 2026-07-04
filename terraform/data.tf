data "aws_ami" "latest_packer_image" {
  most_recent = true
  owners      = ["self"]

  filter {
    name   = "name"
    values = ["packer-ubuntu-golden-image-*"]
  }
}
