variable "resource_group_name" { type = string }
variable "location"            { type = string }
variable "subnet_id"           { type = string }
variable "vm_name"             { type = string }
variable "admin_username"      { type = string }

variable "admin_password"      { 
    type = string  
    sensitive = true 
}

variable "vm_size" {
  type    = string
  default = "Standard_D4s_v5"
}
# ← Only this changes between 22H2 → 23H2 → 24H2 cycles
variable "image_sku" {
  type        = string
  default     = "win11-23h2-avd"
  description = "win11-22h2-avd | win11-23h2-avd | win11-24h2-avd"
}



