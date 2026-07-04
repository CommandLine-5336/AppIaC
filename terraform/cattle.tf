# ==============
# CATTLE
# ==============
# Load Balaner
resource "aws_instance" "lb" {
    ami                         = data.aws_ami.latest_packer_image.id
    instance_type               = var.instance_type
    subnet_id                   = module.vpc.public_subnets[0]
    associate_public_ip_address = true

    private_ip                  = "10.0.101.50"

    vpc_security_group_ids = [aws_security_group.lb.id]
    iam_instance_profile   = module.iam_role.instance_profile_name

    tags = {
        Name        = "lb"
        Role        = "lb"
        Environment = "Dev"
    }
}

# Web Servers
resource "aws_instance" "web" {
    count         = 2
    ami           = data.aws_ami.latest_packer_image.id
    instance_type = var.instance_type
    subnet_id     = module.vpc.private_subnets[0]

    vpc_security_group_ids = [aws_security_group.web.id]
    iam_instance_profile   = module.iam_role.instance_profile_name

    tags = {
        Name        = "Web-${count.index + 1}" 
        Role        = "web"
        Environment = "Dev"
    } 
}