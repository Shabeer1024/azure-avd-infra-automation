output "storage_account_name" {
  value = azurerm_storage_account.script_store.name
}

output "storage_account_key" {
  value     = azurerm_storage_account.script_store.primary_access_key
  sensitive = true
}

output "container_name" {
  value = azurerm_storage_container.script_container.name
}

output "install_script_url" {
  value = azurerm_storage_blob.install_apps.url
}

output "sysprep_script_url" {
  value = azurerm_storage_blob.sysprep.url
}

output "storage_account_id" {
  value = azurerm_storage_account.script_store.id
}



