variable "name" {
  type = string
}

variable "env" {
  type    = string
  default = "Dev"
}

variable "description" {
  type = string
}

variable "vpc_id" {
  type = string
}

variable "tags" {
  type    = map(string)
  default = {}
}

variable "ingress_rules" {
  description = "List of ingress rules"
  type = list(object({
    from_port       = optional(number)
    to_port         = optional(number)
    ip_protocol     = string
    cidr_blocks     = optional(list(string), [])
    security_groups = optional(list(string), [])
    description     = optional(string, "")
  }))
  default = []
}

variable "egress_rules" {
  description = "List of egress rules"
  type = list(object({
    from_port       = optional(number)
    to_port         = optional(number)
    ip_protocol     = string
    cidr_blocks     = optional(list(string), [])
    security_groups = optional(list(string), [])
    description     = optional(string, "")
  }))
  default = [{
    ip_protocol = "-1"
    cidr_blocks = ["0.0.0.0/0"]
    description = "Allow all outbound traffic"
  }]
}