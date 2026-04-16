variable "resource_group_name" { type = string }
variable "location"            { type = string }
variable "subnet_id"           { type = string }
variable "admin_username"      { type = string }
variable "admin_password" {
  type      = string
  sensitive = true
}

variable "vm_name" {
  type    = string
  default = "avd-dc-01"
}

variable "vm_size" {
  type    = string
  default = "Standard_D2s_v3"
}

variable "domain_name" {
  type    = string
  default = "avdlab.local"
}

variable "private_ip_address" {
  type        = string
  default     = "10.0.1.4"
  description = "Static IP for DC — used as DNS server"
}



