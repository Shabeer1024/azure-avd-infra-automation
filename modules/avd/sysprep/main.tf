resource "azurerm_virtual_machine_run_command" "sysprep" {
  name               = "run-sysprep"
  virtual_machine_id = data.azurerm_virtual_machine.build_vm.id
  location           = var.location

  source {
    script = <<-EOT
      $sysprepPath = "C:\Windows\System32\Sysprep\sysprep.exe"
      Start-Process $sysprepPath `
        -ArgumentList "/generalize /oobe /shutdown /quiet" `
        -Wait -NoNewWindow
    EOT
  }
}

data "azurerm_virtual_machine" "build_vm" {
  name                = var.vm_name
  resource_group_name = var.resource_group_name
}



