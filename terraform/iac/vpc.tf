module "vpc" {
  source = "../modules/vpc"

  region               = var.region
  vpc_cidr             = "10.0.0.0/16"
  private_subnet_cidrs = ["10.0.1.0/24", "10.0.2.0/24"]
  public_subnet_cidrs  = ["10.0.101.0/24"]
  env                  = var.environment
  ssm_sg_id            = [module.ssm_sg.id]
}