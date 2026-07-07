data "aws_availability_zones" "available" {
  state = "available"
}

locals {
  availability_zones = data.aws_availability_zones.available.names
}

resource "aws_vpc" "main" {
  cidr_block           = var.vpc_cidr
  instance_tenancy     = "default"
  enable_dns_hostnames = true
  enable_dns_support   = true

  tags = {
    Name        = "${var.env}-cl-vpc"
    Environment = var.env
  }
}

resource "aws_subnet" "public_subnet" {
  vpc_id                  = aws_vpc.main.id
  count                   = length(var.public_subnet_cidrs)
  cidr_block              = element(var.public_subnet_cidrs, count.index)
  availability_zone       = element(local.availability_zones, count.index)
  map_public_ip_on_launch = true

  tags = {
    Name        = "${var.env}-${element(local.availability_zones, count.index)}-public-subnet"
    Environment = var.env
  }
}

resource "aws_route_table" "public_rt" {
  vpc_id = aws_vpc.main.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.igw.id
  }

  tags = {
    Name        = "${var.env}-route-table-public"
    Environment = var.env
  }
}

resource "aws_route_table_association" "public_routes" {
  count          = length(var.public_subnet_cidrs)
  subnet_id      = aws_subnet.public_subnet[count.index].id
  route_table_id = aws_route_table.public_rt.id
}


resource "aws_internet_gateway" "igw" {
  vpc_id = aws_vpc.main.id

  tags = {
    Name        = "${var.env}-igw"
    Environment = var.env
  }
}

resource "aws_eip" "nat_eip" {
  count      = length(var.private_subnet_cidrs)
  domain     = "vpc"
  tags = {
    Name        = "${var.env}-nat-gw-eip-${count.index}"
    Environment = "${var.env}"
  }
}

resource "aws_nat_gateway" "nat" {
  count      = length(var.public_subnet_cidrs)
  allocation_id = aws_eip.nat_eip[count.index].id
  subnet_id     = aws_subnet.public_subnet[count.index].id
  tags = {
    Name        = "${var.env}-nat-gw-${count.index}"
    Environment = "${var.env}"
  }
}

resource "aws_subnet" "private_subnet" {
  vpc_id                  = aws_vpc.main.id
  count                   = length(var.private_subnet_cidrs)
  cidr_block              = element(var.private_subnet_cidrs, count.index)
  availability_zone       = element(local.availability_zones, count.index)
  map_public_ip_on_launch = false

  tags = {
    Name        = "${var.env}-${element(local.availability_zones, count.index)}-private-subnet"
    Environment = var.env
  }
}

resource "aws_route_table" "private_rt" {
  count  = length(var.public_subnet_cidrs)
  vpc_id = aws_vpc.main.id

  route {
    cidr_block     = "0.0.0.0/0"
    nat_gateway_id = aws_nat_gateway.nat[count.index].id
  }

  tags = {
    Name        = "${var.env}-route-table-private-${count.index}"
    Environment = var.env
  }
}

resource "aws_route_table_association" "private_routes" {
  count          = length(var.private_subnet_cidrs)
  subnet_id      = aws_subnet.private_subnet[count.index].id
  route_table_id = aws_route_table.private_rt[count.index % length(var.public_subnet_cidrs)].id
}

resource "aws_vpc_endpoint" "s3" {
  vpc_id            = aws_vpc.main.id
  service_name      = "com.amazonaws.${var.region}.s3"
  vpc_endpoint_type = "Gateway"

  route_table_ids   = concat(
      [aws_route_table.public_rt.id],
      aws_route_table.private_rt[*].id
  )

  tags = {
    Name        = "${var.env}-vpc-s3"
    Environment = var.env
  }
}

resource "aws_vpc_endpoint" "ssm" {
  vpc_id              = aws_vpc.main.id
  service_name        = "com.amazonaws.${var.region}.ssm"
  vpc_endpoint_type   = "Interface"
  subnet_ids          = aws_subnet.private_subnet[*].id
  security_group_ids  = var.ssm_sg_id
  private_dns_enabled = true

  tags = {
    Name        = "${var.env}-vpc-ssm"
    Environment = var.env
  }
}

resource "aws_vpc_endpoint" "ssm_messages" {
  vpc_id              = aws_vpc.main.id
  service_name        = "com.amazonaws.${var.region}.ssmmessages"
  vpc_endpoint_type   = "Interface"
  subnet_ids          = aws_subnet.private_subnet[*].id
  security_group_ids  = var.ssm_sg_id
  private_dns_enabled = true

  tags = {
    Name        = "${var.env}-vpc-ssmmessages"
    Environment = var.env
  }
}

resource "aws_vpc_endpoint" "ec2_messages" {
  vpc_id              = aws_vpc.main.id
  service_name        = "com.amazonaws.us-east-1.ec2messages"
  vpc_endpoint_type   = "Interface"
  subnet_ids          = aws_subnet.private_subnet[*].id
  security_group_ids  = var.ssm_sg_id
  private_dns_enabled = true

  tags = {
    Name        = "${var.env}-vpc-ec2messages"
    Environment = var.env
  }
}