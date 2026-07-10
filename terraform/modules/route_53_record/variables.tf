variable "zone_id" {
  type = string
}

variable "domain_name" {
  type = string
}

variable "type" {
  type = string
}

variable "ttl" {
  type = string
}

variable "records" {
  type = list(string)
}