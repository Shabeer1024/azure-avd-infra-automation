resource "azurerm_storage_account" "script_store" {
  name                     = var.storage_account_name
  resource_group_name      = var.resource_group_name
  location                 = var.location
  account_tier             = "Standard"
  account_replication_type = "LRS"
  min_tls_version          = "TLS1_2"
  tags                     = { role = "script-storage" }
}

resource "azurerm_storage_container" "script_container" {
  name                  = var.container_name
  storage_account_id    = azurerm_storage_account.script_store.id
  container_access_type = "private"
}

resource "azurerm_storage_blob" "install_apps" {
  name                   = "install-apps.ps1"
  storage_account_name   = azurerm_storage_account.script_store.name
  storage_container_name = azurerm_storage_container.script_container.name
  type                   = "Block"
  source_content         = <<-EOT
$ErrorActionPreference = "Stop"
$logFile = "C:\Windows\Temp\install-apps.log"
function Write-Log { param([string]$msg); "$((Get-Date -Format 'yyyy-MM-dd HH:mm:ss')) - $msg" | Tee-Object -FilePath $logFile -Append }
Write-Log "Starting app installation"
$chromePath = "$env:TEMP\chrome_installer.msi"
Invoke-WebRequest -Uri "https://dl.google.com/chrome/install/googlechromestandaloneenterprise64.msi" -OutFile $chromePath -UseBasicParsing
Start-Process msiexec.exe -ArgumentList "/i `"$chromePath`" /qn /norestart" -Wait -NoNewWindow
Write-Log "Chrome installed"
$nppPath = "$env:TEMP\npp_installer.exe"
Invoke-WebRequest -Uri "https://github.com/notepad-plus-plus/notepad-plus-plus/releases/download/v8.6.4/npp.8.6.4.Installer.x64.exe" -OutFile $nppPath -UseBasicParsing
Start-Process $nppPath -ArgumentList "/S" -Wait -NoNewWindow
Write-Log "Notepad++ installed"
Write-Log "All apps installed. Ready for sysprep."
  EOT
}

resource "azurerm_storage_blob" "sysprep" {
  name                   = "sysprep.ps1"
  storage_account_name   = azurerm_storage_account.script_store.name
  storage_container_name = azurerm_storage_container.script_container.name
  type                   = "Block"
  source_content         = "Write-Host 'sysprep placeholder'"
}



