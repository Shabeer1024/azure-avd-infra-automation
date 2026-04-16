output "build_vm_id"   { value = azurerm_windows_virtual_machine.AVD-VM.id }
output "build_vm_name" { value = azurerm_windows_virtual_machine.AVD-VM.name }
output "nic_id"        { value = azurerm_network_interface.AVD-interface.id }
output "private_ip"    { value = azurerm_network_interface.AVD-interface.private_ip_address }



