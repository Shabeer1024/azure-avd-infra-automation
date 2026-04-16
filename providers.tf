terraform {
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "4.60.0"
    }
  }
}

provider "azurerm" {
  features {}
  client_id       = "zzzzzzzz-zzzz-zzzz-zzzz-zzzzzzzzzzzz"
  client_secret   = "DUMMY-SECRET-REPLACE-BEFORE-USE"
  tenant_id       = "xxxxxxxx-xxxx-xxxx-xxxx-xxxxxxxxxxxx"
  subscription_id = "yyyyyyyy-yyyy-yyyy-yyyy-yyyyyyyyyyyy"
}
