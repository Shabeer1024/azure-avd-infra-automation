variable "resource_group_name"  { type = string }
variable "location"             { type = string }
variable "storage_account_name" { type = string }
variable "storage_account_id"   { type = string }
variable "share_name" {
  type    = string
  default = "profiles"
}
variable "share_quota_gb" {
  type    = number
  default = 100
}
variable "session_host_ids" {
  type        = list(string)
  description = "VM IDs of session hosts"
}
variable "domain_name"     { type = string }
variable "admin_username"  { type = string }
variable "admin_password" {
  type      = string
  sensitive = true
}



