variable "ami"{
  description = "Ami for EC2"
  type        = string
}

variable "name" {
  description = "Name of the EC2"
  type        = string
}

variable "role" {
  description = "Role of the EC2"
  type        = string
}

variable "env" {
  description = "Environment"
  type        = string
}

variable "instance_type" {
  description = "EC2 instance type"
  type        = string
  default     = "t3.micro"
}

variable "volume_size" {
  description = "EC2 volume size"
  type        = number
  default     = 8
}

variable "profile_name" {
  description = "EC2 instance profile name"
  type        = string
}

variable "assoc_pub_ip" {
  description = "Will public ip-adress be associated"
  type        = bool
  default     = false
}

variable "pub_ip" {
  description = "Public ip-adress if it is associated"
  type        = string
  default     = null
}

variable "subnet_id" {
  description = "Subnet for EC2 instance"
  type        = string
}

variable "sg_id" {
  description = "Security group if for EC2 instance"
  type        = list(string)
}