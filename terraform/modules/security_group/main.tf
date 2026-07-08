terraform {
  required_version = "1.15.7"
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "6.52.0"
    }
  }
}

resource "aws_security_group" "this" {
  name_prefix = "${var.name}-"
  description = var.description
  vpc_id      = var.vpc_id
  tags = merge({
    Environment = var.env
  }, var.tags)
  lifecycle {
    create_before_destroy = true
  }
}

locals {
  ingress_cidr_rules = flatten([
    for rule_index, rule in var.ingress_rules : [
      for cidr_index, cidr in rule.cidr_blocks : merge(rule, {
        key       = "${rule_index}-cidr-${cidr_index}"
        cidr_ipv4 = cidr
      })
    ]
  ])

  ingress_security_group_rules = flatten([
    for rule_index, rule in var.ingress_rules : [
      for sg_index, sg_id in rule.security_groups : merge(rule, {
        key                          = "${rule_index}-sg-${sg_index}"
        referenced_security_group_id = sg_id
      })
    ]
  ])

  egress_cidr_rules = flatten([
    for rule_index, rule in var.egress_rules : [
      for cidr_index, cidr in rule.cidr_blocks : merge(rule, {
        key       = "${rule_index}-cidr-${cidr_index}"
        cidr_ipv4 = cidr
      })
    ]
  ])
}

resource "aws_vpc_security_group_ingress_rule" "cidr" {
  for_each = { for rule in local.ingress_cidr_rules : rule.key => rule }

  security_group_id = aws_security_group.this.id

  cidr_ipv4   = each.value.cidr_ipv4
  from_port   = each.value.from_port
  to_port     = each.value.to_port
  ip_protocol = each.value.ip_protocol
  description = each.value.description
}

resource "aws_vpc_security_group_ingress_rule" "security_group" {
  for_each = { for rule in local.ingress_security_group_rules : rule.key => rule }

  security_group_id = aws_security_group.this.id

  referenced_security_group_id = each.value.referenced_security_group_id
  from_port                    = each.value.from_port
  to_port                      = each.value.to_port
  ip_protocol                  = each.value.ip_protocol
  description                  = each.value.description
}

resource "aws_vpc_security_group_egress_rule" "out" {
  for_each = { for rule in local.egress_cidr_rules : rule.key => rule }

  security_group_id = aws_security_group.this.id

  cidr_ipv4   = each.value.cidr_ipv4
  from_port   = each.value.from_port
  to_port     = each.value.to_port
  ip_protocol = each.value.ip_protocol
  description = each.value.description
}