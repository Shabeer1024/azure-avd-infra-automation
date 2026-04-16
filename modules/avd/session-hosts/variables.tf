variable "resource_group_name" { type = string }
variable "location"            { type = string }
variable "subnet_id"           { type = string }
variable "admin_username"      { type = string }
variable "admin_password" {
  type      = string
  sensitive = true
}
variable "host_pool_name"      { type = string }
variable "registration_token"  {
  type      = string
  sensitive = true
}
variable "vm_name_prefix" {
  type    = string
  default = "avd-sh"
}
variable "vm_size" {
  type    = string
  default = "Standard_D2s_v3"
}
variable "vm_count" {
  type    = number
  default = 2
}
variable "subscription_id"       { type = string }
variable "gallery_name"          { type = string }
variable "image_definition_name" { type = string }

variable "image_version" {
  type    = string
  default = "1.0.0"
}

variable "enable_session_hosts" {
  type    = bool
  default = true
}



