resource "azurerm_shared_image_gallery" "AVD" {
  name                = var.gallery_name
  resource_group_name = var.resource_group_name
  location            = var.location
  description         = "AVD golden image gallery"
}

resource "azurerm_shared_image" "AVD" {
  name                = var.image_definition_name
  gallery_name        = azurerm_shared_image_gallery.AVD.name
  resource_group_name = var.resource_group_name
  location            = var.location
  os_type             = "Windows"
  hyper_v_generation  = "V2"
  specialized         = false
  identifier {
    publisher = var.publisher
    offer     = var.offer
    sku       = var.sku
  }
}



