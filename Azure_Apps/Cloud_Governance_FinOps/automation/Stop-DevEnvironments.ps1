<#
.SYNOPSIS
    FinOps Automation - Mesai Disi Dev Ortamlari Kapatma Betigi
#>
Import-Module Az.Compute -ErrorAction SilentlyContinue

Write-Output "[*] Gecelik FinOps maliyet optimizasyonu baslatiliyor..."

# Sadece 'Environment' etiketi 'Development' veya 'Test' olan VM'leri getir
$TargetVMs = Get-AzVM | Where-Object { $_.Tags.Environment -match "Development|Test" }

if ($null -eq $TargetVMs) {
    Write-Output "[SUCCESS] Kapatilacak aktif Gelistirme sunucusu bulunamadi."
    Exit 0
}

foreach ($VM in $TargetVMs) {
    $Status = Get-AzVM -ResourceGroupName $VM.ResourceGroupName -Name $VM.Name -Status
    $PowerState = ($Status.Statuses | Where-Object { $_.Code -like "PowerState/*" }).DisplayStatus
    
    if ($PowerState -eq "VM running") {
        Write-Output "[-] Sunucu kapatiliyor ve maliyeti durduruluyor: $($VM.Name)"
        # --force ve -NoWait ile kuyruga atip zaman kaybetmiyoruz
        Stop-AzVM -ResourceGroupName $VM.ResourceGroupName -Name $VM.Name -Force -NoWait | Out-Null
    }
}
Write-Output "[SUCCESS] FinOps kapatma operasyonu tetiklendi."
