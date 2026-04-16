output "domain_join_ids" {
  value = azurerm_virtual_machine_extension.domain_join[*].id
}



