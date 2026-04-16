variable "resource_group_name"   { type = string }
variable "location"              { type = string }
variable "gallery_name"          { type = string }
variable "image_definition_name" { type = string }
variable "publisher" {
  type    = string
  default = "AVDLab"
}
variable "offer" {
  type    = string
  default = "Windows11"
}
variable "sku" {
  type    = string
  default = "multisession"
}



