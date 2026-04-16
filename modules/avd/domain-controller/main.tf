# Windows Server 2022 VM
resource "azurerm_windows_virtual_machine" "dc_vm" {
  name                = var.vm_name
  resource_group_name = var.resource_group_name
  location            = var.location
  size                = var.vm_size
  admin_username      = var.admin_username
  admin_password      = var.admin_password

  network_interface_ids = [azurerm_network_interface.dc_nic.id]

  os_disk {
    caching              = "ReadWrite"
    storage_account_type = "Premium_LRS"
  }

  source_image_reference {
    publisher = "MicrosoftWindowsServer"
    offer     = "WindowsServer"
    sku       = "2022-Datacenter"
    version   = "latest"
  }

  identity {
    type = "SystemAssigned"
  }
}

# Static IP NIC for Domain Controller
resource "azurerm_network_interface" "dc_nic" {
  name                = "${var.vm_name}-nic"
  resource_group_name = var.resource_group_name
  location            = var.location

  ip_configuration {
    name                          = "internal"
    subnet_id                     = var.subnet_id
    private_ip_address_allocation = "Static"
    private_ip_address            = var.private_ip_address
  }
}



# Install AD DS + promote to Domain Controller
resource "azurerm_virtual_machine_extension" "ad_ds" {
  name                 = "InstallADDS"
  virtual_machine_id   = azurerm_windows_virtual_machine.dc_vm.id
  publisher            = "Microsoft.Compute"
  type                 = "CustomScriptExtension"
  type_handler_version = "1.10"

  protected_settings = jsonencode({
    commandToExecute = <<-EOT
      powershell -ExecutionPolicy Unrestricted -Command "
        Install-WindowsFeature -Name AD-Domain-Services -IncludeManagementTools;
        Import-Module ADDSDeployment;
        Install-ADDSForest `
          -DomainName '${var.domain_name}' `
          -DomainNetbiosName 'AVDLAB' `
          -SafeModeAdministratorPassword (ConvertTo-SecureString '${var.admin_password}' -AsPlainText -Force) `
          -InstallDns:$true `
          -Force:$true `
          -NoRebootOnCompletion:$false
      "
    EOT
  })
}



