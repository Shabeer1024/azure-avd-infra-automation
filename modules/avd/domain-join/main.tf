resource "azurerm_virtual_machine_extension" "domain_join" {
  count                = length(var.vm_ids)
  name                 = "DomainJoin"
  virtual_machine_id   = var.vm_ids[count.index]
  publisher            = "Microsoft.Compute"
  type                 = "JsonADDomainExtension"
  type_handler_version = "1.3"

  settings = jsonencode({
    Name    = var.domain_name
    OUPath  = var.ou_path
    User    = "${var.domain_name}\\${var.admin_username}"
    Restart = true
    Options = 3
  })

  protected_settings = jsonencode({
    Password = var.admin_password
  })
}



