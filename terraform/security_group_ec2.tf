module "security_group_web" {
  source = "terraform-aws-modules/security-group/aws"

  name        = "HTTP/HTTPS"
  description = "Allow HTTP/HTTPS inbound traffic for specific ports"
  vpc_id       = module.vpc.vpc_id

  ingress_rules = {
    http = {
      from_port = 80
      ip_protocol = "TCP"
      cidr_ipv4   = "10.0.1.0/24"
      description = "HTTP from internal"
    }
    https = {
      from_port = 443
      ip_protocol = "TCP"
      cidr_ipv4   = "10.0.1.0/24"
      description = "HTTPS from internal"
    }
    self-all = {
      ip_protocol                  = "-1"
      referenced_security_group_id = "self"
      description                  = "All traffic from members of this SG"
    }
  }

  egress_rules = {
    all = {
      ip_protocol = "-1"
      cidr_ipv4   = "0.0.0.0/0"
    }
  }

  tags = {
    Environment = "dev"
  }
}


module "security_group_mariadb" {
  source = "terraform-aws-modules/security-group/aws"

  name        = "MariaDB"
  description = "Allow MariaDB inbound traffic for specific ports"
  vpc_id       = module.vpc.vpc_id

  ingress_rules = {
    tcp = {
      from_port = 3306
      ip_protocol = "TCP"
      cidr_ipv4   = "10.0.2.0/24"
      description = "MariaDB from internal"
    }
    self-all = {
      ip_protocol                  = "-1"
      referenced_security_group_id = "self"
      description                  = "All traffic from members of this SG"
    }
  }

  egress_rules = {
    all = {
      ip_protocol = "-1"
      cidr_ipv4   = "0.0.0.0/0"
    }
  }

  tags = {
    Environment = "dev"
  }
}

module "security_group_jenkins" {
  source = "terraform-aws-modules/security-group/aws"

  name        = "Jenkins"
  description = "Allow Jenkins inbound traffic for specific ports"
  vpc_id       = module.vpc.vpc_id

  ingress_rules = {
    tcp = {
      from_port = 8080
      ip_protocol = "TCP"
      cidr_ipv4   = "10.0.101.0/24"
      description = "Jenkins from internal"
    }
    self-all = {
      ip_protocol                  = "-1"
      referenced_security_group_id = "self"
      description                  = "All traffic from members of this SG"
    }
  }

  egress_rules = {
    all = {
      ip_protocol = "-1"
      cidr_ipv4   = "0.0.0.0/0"
    }
  }

  tags = {
    Environment = "dev"
  }
}



module "security_group_consul" {
  source = "terraform-aws-modules/security-group/aws"

  name        = "Consul"
  description = "Allow Consul inbound traffic for specific ports"
  vpc_id       = module.vpc.vpc_id

  ingress_rules = {
    tcp = {
      from_port = 8500
      ip_protocol = "TCP"
      cidr_ipv4   = "10.0.1.0/24"
      description = "Consul TCP"
    }
    tcp = {
      from_port = 8501
      ip_protocol = "TCP"
      cidr_ipv4   = "10.0.1.0/24"
      description = "Consul HTTPs"
    }
    tcp = {
      from_port = 8300
      ip_protocol = "TCP"
      cidr_ipv4   = "10.0.1.0/24"
      description = "Consul connection to servers"
    }
    self-all = {
      ip_protocol                  = "-1"
      referenced_security_group_id = "self"
      description                  = "All traffic from members of this SG"
    }
  }

  egress_rules = {
    all = {
      ip_protocol = "-1"
      cidr_ipv4   = "0.0.0.0/0"
    }
  }

  tags = {
    Environment = "dev"
  }
}