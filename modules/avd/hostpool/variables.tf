variable "resource_group_name" {
  type = string
}

variable "location" {
  type = string
}

variable "vnet_name" {
    type = string
}

variable "host_pool_name" {
    type = string
}

variable "workspace_name" {
    type = string
}

variable "app_group_name" {
    type = string
}

variable "token_expiry_hours" {
  type    = number
  default = 48
}




