resource "null_resource" "capture_image" {
  provisioner "local-exec" {
    command     = <<-EOT
      az vm deallocate --resource-group ${var.resource_group_name} --name ${var.vm_name}
      az vm generalize --resource-group ${var.resource_group_name} --name ${var.vm_name}
      az sig image-version create --resource-group ${var.resource_group_name} --gallery-name ${var.gallery_name} --gallery-image-definition ${var.image_definition_name} --gallery-image-version ${var.image_version} --virtual-machine /subscriptions/${var.subscription_id}/resourceGroups/${var.resource_group_name}/providers/Microsoft.Compute/virtualMachines/${var.vm_name} --target-regions ${var.location}
    EOT
    interpreter = ["pwsh", "-Command"]
  }

  triggers = {
    vm_name       = var.vm_name
    image_version = var.image_version
  }
}



