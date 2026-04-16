variable "resource_group_name" { type = string }
variable "location"            { type = string }
variable "domain_name"         { type = string }
variable "admin_username"      { type = string }
variable "admin_password" {
  type      = string
  sensitive = true
}
variable "vm_ids" {
  type        = list(string)
  description = "List of VM IDs to domain join"
}
variable "vm_names" {
  type        = list(string)
  description = "List of VM names to domain join"
}
variable "ou_path" {
  type        = string
  default     = ""
  description = "OU path for computer objects"
}



