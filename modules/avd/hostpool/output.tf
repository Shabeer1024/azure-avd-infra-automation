output "host_pool_id" {
  value = azurerm_virtual_desktop_host_pool.AVD.id
}

output "host_pool_name" {
  value = azurerm_virtual_desktop_host_pool.AVD.name
}

output "app_group_id" {
  value = azurerm_virtual_desktop_application_group.AVD.id
}

output "workspace_id" {
  value = azurerm_virtual_desktop_workspace.AVD.id
}

output "registration_token" {
  value     = azurerm_virtual_desktop_host_pool_registration_info.AVD.token
  sensitive = true
}



