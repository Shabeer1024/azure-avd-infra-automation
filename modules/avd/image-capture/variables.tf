variable "resource_group_name"   { type = string }
variable "location"              { type = string }
variable "vm_name"               { type = string }
variable "gallery_name"          { type = string }
variable "image_definition_name" { type = string }
variable "subscription_id"       { type = string }

variable "image_version" {
  type    = string
  default = "1.0.0"
}



