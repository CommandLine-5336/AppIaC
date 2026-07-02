resource "aws_security_group" "lb" {
  name_prefix = "lb"
  description = "Security group for Public/Private Load Balancer"
  vpc_id      = module.vpc.vpc_id
  tags = {
    Environment = "Dev"
  }
  lifecycle {
    create_before_destroy = true
  }
}

resource "aws_vpc_security_group_ingress_rule" "lb_http_web" {
  security_group_id = aws_security_group.lb.id
  description       = "HTTP from internet"
  from_port         = 80
  to_port           = 80
  ip_protocol       = "tcp"
  cidr_ipv4         = "0.0.0.0/0"
}

resource "aws_vpc_security_group_ingress_rule" "lb_https_web" {
  security_group_id = aws_security_group.lb.id
  description       = "HTTPS from internet"
  from_port         = 443
  to_port           = 443
  ip_protocol       = "tcp"
  cidr_ipv4         = "0.0.0.0/0"
}

resource "aws_vpc_security_group_egress_rule" "lb_outbound" {
  security_group_id = aws_security_group.lb.id
  ip_protocol       = "-1"
  cidr_ipv4         = "0.0.0.0/0"
}

resource "aws_security_group" "web" {
  name_prefix = "web"
  description = "Security group for web instances"
  vpc_id      = module.vpc.vpc_id
  tags = {
    Environment = "Dev"
  }
  lifecycle {
    create_before_destroy = true
  }
}
resource "aws_vpc_security_group_ingress_rule" "web_lb" {
  security_group_id = aws_security_group.web.id
  description       = "HTTP from internal"
  from_port         = 80
  to_port           = 80
  ip_protocol       = "tcp"
  cidr_ipv4         = "10.0.1.0/24"
}

resource "aws_vpc_security_group_ingress_rule" "web_self" {
  security_group_id            = aws_security_group.web.id
  description                  = "All traffic from members of this SG"
  ip_protocol                  = "-1"
  referenced_security_group_id = aws_security_group.web.id
}

resource "aws_vpc_security_group_egress_rule" "web_outbound" {
  security_group_id = aws_security_group.web.id
  ip_protocol       = "-1"
  cidr_ipv4         = "0.0.0.0/0"
}

resource "aws_security_group" "MariaDB" {
  name_prefix = "MariaDB"
  description = "Security group for MariaDB instances"
  vpc_id      = module.vpc.vpc_id
  tags = {
    Environment = "Dev"
  }
  lifecycle {
    create_before_destroy = true
  }
}

resource "aws_vpc_security_group_ingress_rule" "db_web" {
  security_group_id = aws_security_group.MariaDB.id
  description       = "MySQL from web servers"
  from_port         = 3306
  to_port           = 3306
  ip_protocol       = "tcp"
  cidr_ipv4         = "10.0.1.0/24"
}

resource "aws_vpc_security_group_ingress_rule" "db_self" {
  security_group_id            = aws_security_group.MariaDB.id
  description                  = "All traffic from members of this SG"
  ip_protocol                  = "-1"
  referenced_security_group_id = aws_security_group.MariaDB.id
}

resource "aws_vpc_security_group_egress_rule" "db_outbound" {
  security_group_id = aws_security_group.MariaDB.id
  description       = "All traffic within VPC"
  ip_protocol       = "-1"
  cidr_ipv4         = "10.0.0.0/16"
}



resource "aws_security_group" "jenkins" {
  name_prefix = "jenkins"
  description = "Allow Jenkins inbound traffic for specific ports"
  vpc_id      = module.vpc.vpc_id
  tags = {
    Environment = "Dev"
  }
  lifecycle {
    create_before_destroy = true
  }
}

resource "aws_vpc_security_group_ingress_rule" "jenkins_tcp" {
  security_group_id = aws_security_group.jenkins.id
  description       = "Jenkins from internal"
  from_port         = 8080
  to_port           = 8080
  ip_protocol       = "tcp"
  cidr_ipv4         = "0.0.0.0/0"
}

resource "aws_vpc_security_group_ingress_rule" "jenkins_self" {
  security_group_id            = aws_security_group.jenkins.id
  description                  = "All traffic from members of this SG"
  ip_protocol                  = "-1"
  referenced_security_group_id = aws_security_group.jenkins.id
}

resource "aws_vpc_security_group_egress_rule" "jenkins_outbound" {
  security_group_id = aws_security_group.jenkins.id
  ip_protocol       = "-1"
  cidr_ipv4         = "0.0.0.0/0"
}

resource "aws_security_group" "consul" {
  name_prefix = "consul"
  description = "Allow Consul inbound traffic for specific ports"
  vpc_id      = module.vpc.vpc_id
  tags = {
    Environment = "Dev"
  }
  lifecycle {
    create_before_destroy = true
  }
}

resource "aws_vpc_security_group_ingress_rule" "consul_tcp" {
  security_group_id = aws_security_group.consul.id
  description       = "Consul TCP"
  from_port         = 8500
  to_port           = 8500
  ip_protocol       = "tcp"
  cidr_ipv4         = "10.0.0.0/16"
}

resource "aws_vpc_security_group_ingress_rule" "consul_https" {
  security_group_id = aws_security_group.consul.id
  description       = "Consul HTTPs"
  from_port         = 8501
  to_port           = 8501
  ip_protocol       = "tcp"
  cidr_ipv4         = "10.0.0.0/16"
}

resource "aws_vpc_security_group_ingress_rule" "consul_server" {
  security_group_id = aws_security_group.consul.id
  description       = "Consul connection to servers"
  from_port         = 8300
  to_port           = 8300
  ip_protocol       = "tcp"
  cidr_ipv4         = "10.0.0.0/16"
}

resource "aws_vpc_security_group_ingress_rule" "consul_self" {
  security_group_id            = aws_security_group.consul.id
  description                  = "All traffic from members of this SG"
  ip_protocol                  = "-1"
  referenced_security_group_id = aws_security_group.consul.id
}

resource "aws_vpc_security_group_egress_rule" "consul_outbound" {
  security_group_id = aws_security_group.consul.id
  ip_protocol       = "-1"
  cidr_ipv4         = "0.0.0.0/0"
}
