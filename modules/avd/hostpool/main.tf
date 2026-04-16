resource "azurerm_virtual_desktop_host_pool" "AVD" {
  name                     = var.host_pool_name
  resource_group_name      = var.resource_group_name
  location                 = var.location
  type                     = "Pooled"
  load_balancer_type       = "BreadthFirst"
  validate_environment     = true
  start_vm_on_connect      = true
  maximum_sessions_allowed = 5
  friendly_name            = "AVD Lab Host Pool"
}

resource "azurerm_virtual_desktop_host_pool_registration_info" "AVD" {
  hostpool_id     = azurerm_virtual_desktop_host_pool.AVD.id
  expiration_date = timeadd(timestamp(), "${var.token_expiry_hours}h")
  lifecycle {
    ignore_changes = [expiration_date]
  }
}

resource "azurerm_virtual_desktop_workspace" "AVD" {
  name                = var.workspace_name
  resource_group_name = var.resource_group_name
  location            = var.location
  friendly_name       = "AVD Lab Workspace"
}

resource "azurerm_virtual_desktop_application_group" "AVD" {
  name                = var.app_group_name
  resource_group_name = var.resource_group_name
  location            = var.location
  type                = "Desktop"
  host_pool_id        = azurerm_virtual_desktop_host_pool.AVD.id
}

resource "azurerm_virtual_desktop_workspace_application_group_association" "AVD" {
  workspace_id         = azurerm_virtual_desktop_workspace.AVD.id
  application_group_id = azurerm_virtual_desktop_application_group.AVD.id
}



