<#
.SYNOPSIS
    Kurumsal Ağ Paylaşımı Üzerinden Donanım Bypasslı Windows 11 Yükseltme Betiği
#>

# 1. Kurumsal Ağ Paylaşım Yolu ve Log Tanımları
$NetworkISOPath = "\\kurumsal-nas\iso\Windows11_24H2_Enterprise.iso"
$LocalLogPath = "C:\Windows\Logs\Windows11_Upgrade.log"

Start-Transcript -Path $LocalLogPath -Append

Write-Output "[*] $(Get-Date): Windows 11 Yukseltme Analizi Basladi..."

# 2. Donanım (TPM 2.0 ve CPU) Kısıtlamalarını Aşma (Registry Bypass)
Write-Output "[*] Donanim kisitlamalari icin kayit defteri guncelleniyor..."
$BypassPath = "HKLM:\SYSTEM\Setup\MoSetup"
if (-not (Test-Path $BypassPath)) {
    New-Item -Path $BypassPath -Force | Out-Null
}
# Desteklenmeyen CPU ve TPM'e sahip makinelerin kuruluma devam etmesini sağlayan Microsoft parametresi
New-ItemProperty -Path $BypassPath -Name "AllowUpgradesWithUnsupportedTPMOrCPU" -Value 1 -PropertyType DWord -Force | Out-Null

# 3. ISO Dosyasının Ağ Paylaşımından Çekilerek Mount Edilmesi
if (Test-Path $NetworkISOPath) {
    Write-Output "[*] ISO dosyasi ag paylasiminda bulundu. Mount ediliyor..."
    try {
        $MountResult = Mount-DiskImage -ImagePath $NetworkISOPath -PassThru
        $DriveLetter = ($MountResult | Get-Volume).DriveLetter
        Write-Output "[SUCCESS] ISO basariyla mount edildi. Surucu Harfi: ${DriveLetter}:"
        
        # 4. Sessiz (Silent) Kurulum Kurallarının Tetiklenmesi
        Write-Output "[*] Windows 11 Setup arka planda baslatiliyor..."
        $SetupPath = "${DriveLetter}:\setup.exe"
        
        # Kurumsal parametreler: Arayüz gösterme, dinamik güncellemeleri geç, verileri koru, reboot'u yönet
        $SetupArguments = "/auto upgrade /quiet /noreboot /dynamicupdate disable /showoobe none"
        
        Start-Process -FilePath $SetupPath -ArgumentList $SetupArguments -Wait
        Write-Output "[SUCCESS] Kurulum paketi basariyla uygulandi. Makine ilk yeniden baslatmada Windows 11'e gececek."
    }
    catch {
        Write-Error "[ERROR] Kurulum esnasinda bir hata olustu: $_"
    }
    finally {
        # İşlem bittiğinde ISO'yu serbest bırak
        Dismount-DiskImage -ImagePath $NetworkISOPath | Out-Null
    }
} else {
    Write-Warning "[ALERT] Ag paylasimindaki ISO dosyasina erisilemedi: $NetworkISOPath"
}

Stop-Transcript
