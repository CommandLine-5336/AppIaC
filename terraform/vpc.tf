module "vpc" {
  source = "terraform-aws-modules/vpc/aws"

  name = "cl-vpc"
  cidr = "10.0.0.0/16"

  azs = ["us-east-1a"]
  #private subnets for: load balancer, web1, web2, jenkins, consul and for mariadb
  private_subnets = ["10.0.1.0/24", "10.0.2.0/24"]
  #public subnet for load balancer
  public_subnets = ["10.0.101.0/24"]

  enable_nat_gateway = true
  single_nat_gateway = true

  tags = {
    Terraform   = "true"
    Environment = "Dev"
  }
}

resource "aws_vpc_endpoint" "s3" {
  vpc_id            = module.vpc.vpc_id
  service_name      = "com.amazonaws.us-east-1.s3"
  vpc_endpoint_type = "Gateway"
  route_table_ids   = concat(module.vpc.private_route_table_ids, module.vpc.public_route_table_ids)
}
