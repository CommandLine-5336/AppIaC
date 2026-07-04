# ==============
# PETS
# ==============
# Jenkins
resource "aws_instance" "jenkins" {
    ami                         = data.aws_ami.latest_packer_image.id
    instance_type               = var.instance_type
    subnet_id                   = module.vpc.public_subnets[0]
    associate_public_ip_address = true

    vpc_security_group_ids  = [aws_security_group.jenkins.id]
    iam_instance_profile    = module.iam_role.instance_profile_name

    tags = {
        Name        = "jenkins"
        Role        = "jenkins"
         Environment = "Dev"
    }
}

# DB Maria
resource "aws_instance" "mariadb" {
    ami           = data.aws_ami.latest_packer_image.id
    instance_type = var.instance_type
    subnet_id     = module.vpc.private_subnets[1]

   vpc_security_group_ids = [aws_security_group.MariaDB.id]
    iam_instance_profile   = module.iam_role.instance_profile_name

    tags = {
        Name        = "db"
        Role        = "db"
        Environment = "Dev"
    }
}

# Consul Server
resource "aws_instance" "consul" {
    ami           = data.aws_ami.latest_packer_image.id
    instance_type = var.instance_type
    subnet_id     = module.vpc.private_subnets[0]

    vpc_security_group_ids = [aws_security_group.consul.id]
    iam_instance_profile   = module.iam_role.instance_profile_name

    tags = {
        Name        = "consul"
        Role        = "consul"
        Environment = "Dev"
    }
}