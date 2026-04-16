data "azurerm_virtual_machine" "build_vm" {
  name                = var.vm_name
  resource_group_name = var.resource_group_name
}

resource "azurerm_virtual_machine_extension" "app_install" {
  name                 = "install-apps"
  virtual_machine_id   = data.azurerm_virtual_machine.build_vm.id
  publisher            = "Microsoft.Compute"
  type                 = "CustomScriptExtension"
  type_handler_version = "1.10"

  protected_settings = jsonencode({
    storageAccountName = var.storage_account_name
    storageAccountKey  = var.storage_account_key
    fileUris = [
      "https://${var.storage_account_name}.blob.core.windows.net/${var.container_name}/${var.script_filename}"
    ]
    commandToExecute = "powershell -ExecutionPolicy Unrestricted -File ${var.script_filename}"
  })

  tags = { role = "app-install" }
}



