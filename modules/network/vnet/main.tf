# Virtual Network
resource "azurerm_virtual_network" "Vnet01" {
  name                = var.vnet_name
  resource_group_name = var.resource_group_name
  location            = var.location
  address_space       = [var.vnet_address_prefix]
  dns_servers         = var.dns_servers
  tags                = { role = "vnet" }
}

# Subnets — count based, auto increments
resource "azurerm_subnet" "Network_subnets" {
  count                = var.vnet_subnet_count
  name                 = "subnet${count.index}"
  resource_group_name  = var.resource_group_name
  virtual_network_name = azurerm_virtual_network.Vnet01.name
  address_prefixes     = [cidrsubnet(var.vnet_address_prefix, 8, count.index)]
}



