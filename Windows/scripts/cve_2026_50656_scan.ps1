<#
.SYNOPSIS
    CVE-2026-50656 (RoguePlanet) Zafiyet Tarama ve Tespit Betiği
#>
$VulnerabilityName = "CVE-2026-50656-RoguePlanet"
$TargetRegistryPath = "HKLM:\SOFTWARE\Microsoft\Windows Defender\Features"
$TargetValueName = "RoguePlanetMitigation"

Write-Output "[*] $VulnerabilityName icin sistem analizi baslatiliyor..."

# 1. Kayit Defteri (Registry) Kontrolü ile yamanin varliğini sorgula
if (Test-Path $TargetRegistryPath) {
    $MitigationState = Get-ItemProperty -Path $TargetRegistryPath -Name $TargetValueName -ErrorAction SilentlyContinue
    
    if ($MitigationState.$TargetValueName -eq 1) {
        Write-Output "[SUCCESS] Sistem guvende. Koruma mekanizmasi aktif."
        Exit 0 # Endpoint Central bu kodu 'Uyumlu / Vunlerability yok' kabul eder.
    }
}

# 2. Eğer değer bulunamadiysa sistem risk altindadir
Write-Warning "[ALERT] Sistem risk altinda! Gerekli kayit defteri degeri eksik veya pasif."
Exit 1 # Endpoint Central bu kodu 'Zafiyet Var / Remediation Gerekli' olarak raporlar.
EOF