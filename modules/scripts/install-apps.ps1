$ErrorActionPreference = "Stop"
$logFile = "C:\Windows\Temp\install-apps.log"

function Write-Log {
    param([string]$msg)
    $timestamp = Get-Date -Format "yyyy-MM-dd HH:mm:ss"
    "$timestamp - $msg" | Tee-Object -FilePath $logFile -Append
}

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