variable "vpc_cidr" {
    default = "10.0.0.0/16"
}

variable "env" {
    default = "Dev"
}

variable "region" {
    type = string
    default = "us-east-1"
}

variable "public_subnet_cidrs" {
    default = [
        "10.0.1.0/24",
        "10.0.2.0/24",
    ]
}

variable "private_subnet_cidrs" {
    default = [
        "10.0.101.0/24"
    ]
}

variable "ssm_sg_id" {
    type = list(string)
    default = null
}