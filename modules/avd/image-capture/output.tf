output "image_version" {
  value = var.image_version
}

output "image_version_id" {
  value = "/subscriptions/${var.subscription_id}/resourceGroups/${var.resource_group_name}/providers/Microsoft.Compute/galleries/${var.gallery_name}/images/${var.image_definition_name}/versions/${var.image_version}"
}



