terraform {
  backend "azurerm" {
    resource_group_name  = "AVD-TF-State"
    storage_account_name = "avdtfstate001"
    container_name       = "tfstate"
    key                  = "dr.terraform.tfstate"
  }
}