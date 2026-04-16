# Azure Files share for FSLogix profiles
resource "azurerm_storage_share" "profiles" {
  name               = var.share_name
  storage_account_id = var.storage_account_id
  quota              = var.share_quota_gb
}

# RBAC — session hosts get Storage File Data SMB Share Contributor
resource "azurerm_role_assignment" "fslogix_smb" {
  count                = length(var.session_host_ids)
  scope                = var.storage_account_id
  role_definition_name = "Storage File Data SMB Share Contributor"
  principal_id         = data.azurerm_virtual_machine.session_hosts[count.index].identity[0].principal_id
}

data "azurerm_virtual_machine" "session_hosts" {
  count               = length(var.session_host_ids)
  resource_group_name = var.resource_group_name
  name                = element(split("/", var.session_host_ids[count.index]), length(split("/", var.session_host_ids[count.index])) - 1)
}

# Configure FSLogix on each session host via registry
# resource "azurerm_virtual_machine_extension" "fslogix_config" {
#   count                = length(var.session_host_ids)
#   name                 = "FSLogixConfig"
#   virtual_machine_id   = var.session_host_ids[count.index]
#   publisher            = "Microsoft.Compute"
#   type                 = "CustomScriptExtension"
#   type_handler_version = "1.10"

#   protected_settings = jsonencode({
#     commandToExecute = <<-EOT
#       powershell -ExecutionPolicy Unrestricted -Command "
#         # Enable FSLogix
#         New-Item -Path 'HKLM:\SOFTWARE\FSLogix\Profiles' -Force
#         Set-ItemProperty -Path 'HKLM:\SOFTWARE\FSLogix\Profiles' -Name 'Enabled' -Value 1
#         Set-ItemProperty -Path 'HKLM:\SOFTWARE\FSLogix\Profiles' -Name 'VHDLocations' -Value '\\\\${var.storage_account_name}.file.core.windows.net\\${var.share_name}'
#         Set-ItemProperty -Path 'HKLM:\SOFTWARE\FSLogix\Profiles' -Name 'DeleteLocalProfileWhenVHDShouldApply' -Value 1
#         Set-ItemProperty -Path 'HKLM:\SOFTWARE\FSLogix\Profiles' -Name 'FlipFlopProfileDirectoryName' -Value 1
#         Set-ItemProperty -Path 'HKLM:\SOFTWARE\FSLogix\Profiles' -Name 'SizeInMBs' -Value 30000
#         Write-Host 'FSLogix configured successfully'
#       "
#     EOT
#   })

#   tags = { role = "fslogix-config" }
# }

resource "azurerm_virtual_machine_extension" "fslogix_config" {
  count                = length(var.session_host_ids)
  name                 = "FSLogixConfig"
  virtual_machine_id   = var.session_host_ids[count.index]
  publisher            = "Microsoft.Compute"
  type                 = "CustomScriptExtension"
  type_handler_version = "1.10"

  protected_settings = jsonencode({
    commandToExecute = "powershell -ExecutionPolicy Unrestricted -Command \"New-Item -Path 'HKLM:\\SOFTWARE\\FSLogix\\Profiles' -Force; Set-ItemProperty -Path 'HKLM:\\SOFTWARE\\FSLogix\\Profiles' -Name 'Enabled' -Value 1; Set-ItemProperty -Path 'HKLM:\\SOFTWARE\\FSLogix\\Profiles' -Name 'VHDLocations' -Value '\\\\\\\\${var.storage_account_name}.file.core.windows.net\\\\${var.share_name}'; Set-ItemProperty -Path 'HKLM:\\SOFTWARE\\FSLogix\\Profiles' -Name 'SizeInMBs' -Value 30000; Set-ItemProperty -Path 'HKLM:\\SOFTWARE\\FSLogix\\Profiles' -Name 'FlipFlopProfileDirectoryName' -Value 1\""
  })
}



