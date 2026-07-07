module "ssm_sg" {
  source = "../modules/security_group"

  name        = "ssm"
  description = "Security group for ssm servers"
  vpc_id      = module.vpc.id

  ingress_rules = [
    {
      from_port   = 443
      to_port     = 443
      ip_protocol = "tcp"
      cidr_blocks = ["10.0.0.0/16"]
      description = "HTTPS from VPC"
    }
  ]

  egress_rules = [
    {
      ip_protocol = "-1"
      cidr_blocks = ["0.0.0.0/0"]
    }
  ]

  tags = {
    Environment = "Dev"
  }
}

module "jenkins_sg" {
  source = "../modules/security_group"

  name        = "jenkins"
  description = "Security group for jenkins"
  vpc_id      = module.vpc.id

  ingress_rules = [
    {
      from_port   = 8080
      to_port     = 8080
      ip_protocol = "tcp"
      cidr_blocks = ["10.0.1.0/24"]
      description = "Jenkins from internal"
    },
    {
      description                  = "All traffic from members of this SG"
      ip_protocol                  = "-1"
      referenced_security_group_id = module.jenkins_sg.id
    }
  ]

  egress_rules = [
    {
      ip_protocol = "-1"
      cidr_blocks = ["0.0.0.0/0"]
    }
  ]

  tags = {
    Environment = "Dev"
  }
}

module "lb_sg" {
  source = "../modules/security_group"

  name        = "lb"
  description = "Security group for Load Balancer"
  vpc_id      = module.vpc.id

  ingress_rules = [
    {
      from_port   = 443
      to_port     = 443
      ip_protocol = "tcp"
      cidr_blocks = ["0.0.0.0/0"]
      description = "HTTPS from internet"
    },
    {
      from_port   = 80
      to_port     = 80
      ip_protocol = "tcp"
      cidr_blocks = ["0.0.0.0/0"]
      description = "HTTP from internet"
    },
    {
      from_port                    = 22
      to_port                      = 22
      ip_protocol                  = "tcp"
      referenced_security_group_id = module.jenkins_sg.id
      description                  = "SSH from jenkins"
    },
    {
      description                  = "All traffic from members of this SG"
      ip_protocol                  = "-1"
      referenced_security_group_id = module.lb_sg.id
    }
  ]

  egress_rules = [
    {
      ip_protocol = "-1"
      cidr_blocks = ["0.0.0.0/0"]
    }
  ]

  tags = {
    Environment = "Dev"
  }
}

module "web_sg" {
  source = "../modules/security_group"

  name        = "web"
  description = "Security group for web servers"
  vpc_id      = module.vpc.id

  ingress_rules = [
    {
      from_port   = 80
      to_port     = 80
      ip_protocol = "tcp"
      cidr_blocks = ["10.0.1.0/24"]
      description = "HTTP from internal"
    },
    {
      from_port                    = 22
      to_port                      = 22
      ip_protocol                  = "tcp"
      referenced_security_group_id = module.jenkins_sg.id
      description                  = "SSH from jenkins"
    },
    {
      description                  = "All traffic from members of this SG"
      ip_protocol                  = "-1"
      referenced_security_group_id = module.web_sg.id
    }
  ]

  egress_rules = [
    {
      ip_protocol = "-1"
      cidr_blocks = ["0.0.0.0/0"]
    }
  ]

  tags = {
    Environment = "Dev"
  }
}

module "db_sg" {
  source = "../modules/security_group"

  name        = "db"
  description = "Security group for db servers"
  vpc_id      = module.vpc.id

  ingress_rules = [
    {
      from_port                    = 3306
      to_port                      = 3306
      ip_protocol                  = "tcp"
      referenced_security_group_id = module.web_sg.id
      description                  = "MariaDB from web"
    },
    {
      from_port                    = 22
      to_port                      = 22
      ip_protocol                  = "tcp"
      referenced_security_group_id = module.jenkins_sg.id
      description                  = "SSH from jenkins"
    },
    {
      description                  = "All traffic from members of this SG"
      ip_protocol                  = "-1"
      referenced_security_group_id = module.db_sg.id
    }
  ]

  egress_rules = [
    {
      ip_protocol = "-1"
      cidr_blocks = ["0.0.0.0/0"]
    }
  ]


  tags = {
    Environment = "Dev"
  }
}

module "consul_sg" {
  source = "../modules/security_group"

  name        = "consul"
  description = "Security group for consul servers"
  vpc_id      = module.vpc.id

  ingress_rules = [
    {
      from_port   = 8500
      to_port     = 8500
      ip_protocol = "tcp"
      cidr_blocks = ["10.0.0.0/16"]
      description = "Consul TCP"
    },
    {
      from_port   = 8501
      to_port     = 8501
      ip_protocol = "tcp"
      cidr_blocks = ["10.0.0.0/16"]
      description = "Consul HTTPS"
    },
    {
      from_port   = 8300
      to_port     = 8300
      ip_protocol = "tcp"
      cidr_blocks = ["10.0.0.0/16"]
      description = "Consul HTTP"
    },
    {
      from_port                    = 22
      to_port                      = 22
      ip_protocol                  = "tcp"
      referenced_security_group_id = module.jenkins_sg.id
      description                  = "SSH from jenkins"
    },
    {
      description                  = "All traffic from members of this SG"
      ip_protocol                  = "-1"
      referenced_security_group_id = module.consul_sg.id
    }
  ]

  egress_rules = [
    {
      ip_protocol = "-1"
      cidr_blocks = ["0.0.0.0/0"]
    }
  ]


  tags = {
    Environment = "Dev"
  }
}
