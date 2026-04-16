output "session_host_ids" {
  value = azurerm_windows_virtual_machine.session_host[*].id
}

output "session_host_names" {
  value = azurerm_windows_virtual_machine.session_host[*].name
}



