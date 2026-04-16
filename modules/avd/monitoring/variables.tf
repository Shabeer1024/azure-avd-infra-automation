variable "resource_group_name" { type = string }
variable "location"            { type = string }



variable "host_pool_id"         { type = string }
variable "host_pool_name"       { type = string }
variable "session_host_ids" {
  type = list(string)
}
variable "alert_email" {
  type        = string
  description = "Email address for alerts"
}

variable "workspace_name" {
  type    = string
  default = "avd-log-analytics"
}

variable "dc_vm_id"    { type = string }



