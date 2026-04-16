output "vnet_id" {
  value = azurerm_virtual_network.Vnet01.id
}

output "vnet_name" {
  value = azurerm_virtual_network.Vnet01.name
}

output "subnet_id" {
  description = "First subnet — backward compatible"
  value       = azurerm_subnet.Network_subnets[0].id
}

output "subnet_ids" {
  description = "All subnet IDs"
  value       = azurerm_subnet.Network_subnets[*].id
}

output "avd_subnet_id" {
  description = "subnet0 — AVD session hosts"
  value       = azurerm_subnet.Network_subnets[0].id
}

output "dc_subnet_id" {
  description = "subnet1 — Domain Controller"
  value       = azurerm_subnet.Network_subnets[1].id
}



