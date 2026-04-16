data "azurerm_shared_image_version" "golden" {
  count               = var.enable_session_hosts ? 1 : 0
  name                = var.image_version
  image_name          = var.image_definition_name
  gallery_name        = var.gallery_name
  resource_group_name = var.resource_group_name
}

resource "azurerm_network_interface" "session_host_nic" {
  count               = var.enable_session_hosts ? var.vm_count : 0
  name                = "${var.vm_name_prefix}-${count.index}-nic"
  resource_group_name = var.resource_group_name
  location            = var.location

  ip_configuration {
    name                          = "internal"
    subnet_id                     = var.subnet_id
    private_ip_address_allocation = "Dynamic"
  }
  tags = { role = "session-host-nic" }
}

resource "azurerm_windows_virtual_machine" "session_host" {
  count                 = var.enable_session_hosts ? var.vm_count : 0
  name                  = "${var.vm_name_prefix}-${count.index}"
  resource_group_name   = var.resource_group_name
  location              = var.location
  size                  = var.vm_size
  admin_username        = var.admin_username
  admin_password        = var.admin_password
  network_interface_ids = [azurerm_network_interface.session_host_nic[count.index].id]

  os_disk {
    caching              = "ReadWrite"
    storage_account_type = "Premium_LRS"
  }

  source_image_id = data.azurerm_shared_image_version.golden[0].id

  identity { type = "SystemAssigned" }

  tags = {
    role          = "session-host"
    image_version = var.image_version
  }
}

resource "azurerm_virtual_machine_extension" "avd_agent" {
  count                = var.enable_session_hosts ? var.vm_count : 0
  name                 = "AVDAgent"
  virtual_machine_id   = azurerm_windows_virtual_machine.session_host[count.index].id
  publisher            = "Microsoft.Powershell"
  type                 = "DSC"
  type_handler_version = "2.73"

  settings = jsonencode({
    modulesUrl            = "https://wvdportalstorageblob.blob.core.windows.net/galleryartifacts/Configuration_09-08-2022.zip"
    configurationFunction = "Configuration.ps1\\AddSessionHost"
    properties = {
      HostPoolName          = var.host_pool_name
      RegistrationInfoToken = var.registration_token
      aadJoin               = false
    }
  })

  tags = { role = "avd-agent" }
}



