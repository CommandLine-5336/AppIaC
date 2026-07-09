module "lb_ec2" {
  source = "../modules/ec2"
  ami    = data.aws_ami.packer_image.id

  name         = "lb"
  role         = "lb"
  env          = var.environment
  profile_name = module.lb_role.instance_profile_name
  subnet_id    = module.vpc.public_subnets[0]
  assoc_pub_ip = true
  pub_ip       = "10.0.101.50"
  sg_id        = [module.lb_sg.id]
}

module "web_ec2" {
  source = "../modules/ec2"
  count  = 2
  ami    = data.aws_ami.packer_image.id

  name         = "web0${count.index + 1}"
  role         = "web"
  env          = var.environment
  profile_name = module.web_role.instance_profile_name
  subnet_id    = module.vpc.private_subnets[0]
  sg_id        = [module.web_sg.id]
}

module "jenkins_ec2" {
  source = "../modules/ec2"

  ami           = data.aws_ami.packer_image_jenkins.id
  name          = "jenkins"
  role          = "jenkins"
  env           = var.environment
  instance_type = "t3.medium"
  volume_size   = 20
  profile_name  = module.jenkins_role.instance_profile_name
  subnet_id     = module.vpc.private_subnets[0]
  sg_id         = [module.jenkins_sg.id]
}

module "db_ec2" {
  source = "../modules/ec2"
  ami    = data.aws_ami.packer_image.id

  name         = "db"
  role         = "db"
  env          = var.environment
  profile_name = module.db_consul_role.instance_profile_name
  subnet_id    = module.vpc.private_subnets[1]
  sg_id        = [module.db_sg.id]
}

module "consul_ec2" {
  source = "../modules/ec2"
  ami    = data.aws_ami.packer_image.id

  name         = "consul"
  role         = "consul"
  env          = var.environment
  profile_name = module.db_consul_role.instance_profile_name
  subnet_id    = module.vpc.private_subnets[0]
  sg_id        = [module.consul_sg.id]
}



