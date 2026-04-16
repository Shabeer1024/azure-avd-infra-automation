# Create sysprep.ps1 placeholder
@'
# Stage 3 - Sysprep placeholder
# Real content added in next stage
Write-Host "sysprep placeholder"
'@ | Out-File -FilePath scripts\sysprep.ps1 -Encoding utf8