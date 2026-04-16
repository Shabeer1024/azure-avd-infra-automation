variable "resource_group_name" { type = string }
variable "location"            { type = string }
variable "host_pool_id"        { type = string }
variable "host_pool_name"      { type = string }

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

variable "minimum_hosts_percent" {
  type    = number
  default = 20
  description = "Minimum % of hosts to keep running during off-peak"
}

variable "capacity_threshold_percent" {
  type    = number
  default = 75
  description = "% capacity to trigger scale out"
}



