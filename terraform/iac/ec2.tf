module "lb_ec2" {
  source = "../modules/ec2"

  name         = "lb"
  role         = "lb"
  env          = "Dev"
  profile_name = module.ec2_role.instance_profile_name
  subnet_id    = module.vpc.public_subnets[0]
  assoc_pub_ip = true
  pub_ip       = "10.0.101.50"
  sg_id        = [module.lb_sg.id]
}

module "web_ec2" {
  source = "../modules/ec2"
  count  = 2

  name         = "web0${count.index + 1}"
  role         = "web"
  env          = "Dev"
  profile_name = module.ec2_role.instance_profile_name
  subnet_id    = module.vpc.private_subnets[0]
  sg_id        = [module.web_sg.id]
}

module "jenkins_ec2" {
  source = "../modules/ec2"

  name         = "jenkins"
  role         = "jenkins"
  env          = "Dev"
  profile_name = module.ec2_role.instance_profile_name
  subnet_id    = module.vpc.private_subnets[0]
  sg_id        = [module.jenkins_sg.id]
}

module "db_ec2" {
  source = "../modules/ec2"

  name         = "db"
  role         = "db"
  env          = "Dev"
  profile_name = module.ec2_role.instance_profile_name
  subnet_id    = module.vpc.private_subnets[1]
  sg_id        = [module.db_sg.id]
}

module "consul_ec2" {
  source = "../modules/ec2"

  name         = "consul"
  role         = "consul"
  env          = "Dev"
  profile_name = module.ec2_role.instance_profile_name
  subnet_id    = module.vpc.private_subnets[0]
  sg_id        = [module.consul_sg.id]
}



