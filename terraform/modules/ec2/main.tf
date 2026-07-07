resource "aws_instance" "this" {
  ami                         = data.aws_ami.latest_packer_image.id
  instance_type               = var.instance_type
  subnet_id                   = var.subnet_id
  associate_public_ip_address = var.assoc_pub_ip
  private_ip                  = var.assoc_pub_ip ? var.pub_ip : null

  vpc_security_group_ids = var.sg_id
  iam_instance_profile   = var.profile_name

  tags = {
    Name        = "${var.name}"
    Role        = "${var.role}"
    Environment = "${var.env}"
  }
}