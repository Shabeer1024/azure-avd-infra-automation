output "share_name" {
  value = azurerm_storage_share.profiles.name
}

output "share_url" {
  value = "\\\\${var.storage_account_name}.file.core.windows.net\\${var.share_name}"
}

output "share_id" {
  value = azurerm_storage_share.profiles.id
}



