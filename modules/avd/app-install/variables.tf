variable "resource_group_name"  { type = string }
variable "location"             { type = string }
variable "vm_name"              { type = string }
variable "storage_account_name" { type = string }
variable "storage_account_key" {
  type      = string
  sensitive = true
}
variable "container_name" {
  type    = string
  default = "scripts"
}
variable "script_filename" {
  type    = string
  default = "install-apps.ps1"
}



