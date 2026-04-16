variable "resource_group_name" { type = string }
variable "location"            { type = string }
variable "vnet_name"           { type = string }
variable "vnet_address_prefix" { type = string }

variable "avd_subnet_prefix" {
  type    = string
  default = "10.0.0.0/24"
}

variable "vnet_subnet_count" {
  type    = number
  default = 2
}

variable "dc_subnet_prefix" {
  type    = string
  default = "10.0.1.0/24"
}

variable "dns_servers" {
  type    = list(string)
  default = []
}



