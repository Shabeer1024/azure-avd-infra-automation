variable "resource_group_name" { type = string }
variable "location" { type = string }
variable "vnet_name" { type = string }
variable "vnet_address_prefix" { type = string }
variable "vnet_subnet_count" { type = number }
# variable "storage_account_name" { type = string }
variable "gallery_name" { type = string }
variable "host_pool_name" { type = string } 
variable "app_group_name" { type = string }
variable "build_vm_name" { type = string }
variable "admin_username" { type = string }

variable "image_definition_name" {
  type    = string
  default = "avd-win11-multisession"
}

variable "token_expiry_hours" {
  type    = number
  default = 48
}

variable "build_vm_size" {
  type    = string
  default = "Standard_D4s_v5"
}

variable "build_image_sku" {
  type    = string
  default = "win11-23h2-avd"
}

variable "admin_password" {
  type      = string
  sensitive = true
}

variable "storage_account_name" { type = string }

variable "subscription_id" { type = string }

variable "image_version" {
  type    = string
  default = "1.0.0"
}

variable "session_host_count" {
  type    = number
  default = 2
}

variable "enable_session_hosts" {
  type    = bool
  default = true
}

# Domain Controller
variable "dc_vm_name" {
  type    = string
  default = "avd-dc-01"
}

variable "dc_vm_size" {
  type    = string
  default = "Standard_D2s_v3"
}

variable "domain_name" {
  type    = string
  default = "avdlab.local"
}

variable "dc_private_ip" {
  type    = string
  default = "10.0.1.4"
}

variable "avd_subnet_prefix" {
  type    = string
  default = "10.0.0.0/24"
}

variable "dc_subnet_prefix" {
  type    = string
  default = "10.0.1.0/24"
}

variable "dns_servers" {
  type    = list(string)
  default = []
}

variable "fslogix_share_name" {
  type    = string
  default = "profiles"
}

variable "fslogix_share_quota" {
  type    = number
  default = 100
}



variable "alert_email" {
  type        = string
  description = "Email for AVD alerts"
}

# AVD Workspace name
variable "workspace_name" {
  type    = string
  default = "avd-lab-workspace"
}

# Log Analytics Workspace name
variable "log_analytics_workspace_name" {
  type    = string
  default = "avd-log-analytics"
}

variable "scaling_plan_name" {
  type    = string
  default = "avd-scaling-plan"
}

variable "time_zone" {
  type    = string
  default = "UTC"
}

variable "peak_start_time" {
  type    = string
  default = "09:00"
}

variable "peak_end_time" {
  type    = string
  default = "18:00"
}

variable "ramp_up_start_time" {
  type    = string
  default = "06:00"
}

variable "off_peak_start_time" {
  type    = string
  default = "20:00"
}



