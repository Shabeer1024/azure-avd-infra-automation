output "dc_vm_id" {
  value = azurerm_windows_virtual_machine.dc_vm.id
}

output "dc_vm_name" {
  value = azurerm_windows_virtual_machine.dc_vm.name
}

output "dc_private_ip" {
  value = azurerm_network_interface.dc_nic.private_ip_address
}

output "domain_name" {
  value = var.domain_name
}



