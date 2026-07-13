<#
.SYNOPSIS
    Active Directory Merkezi Denetim - Son 1 Saatlik Basarili Logon Raporu
.DESCRIPTION
    Event ID 4624 (Successful Logon) kayitlarini suzer ve kurumsal analiz icin hazırlar.
#>

$TargetTime = (Get-Date).AddHours(-1)
Write-Output "[*] Son 1 saat icindeki ($TargetTime) basarili oturum acma etkinlikleri taraniyor..."

# Event ID 4624: Successful Logon
$LogonEvents = Get-WinEvent -FilterHashtable @{
    LogName   = 'Security'
    Id        = 4624
    StartTime = $TargetTime
} -ErrorAction SilentlyContinue

if ($null -eq $LogonEvents) {
    Write-Output "[SUCCESS] Son 1 saat icinde sirdisi veya taranacak oturum acma aktivitesi bulunamadi."
    Exit 0
}

$Report = foreach ($Event in $LogonEvents) {
    $XML = [xml]$Event.ToXml()
    # Event XML semasindan kullanici ve IP verilerini ayristiralım
    $TargetUserName = ($XML.Event.EventData.Data | Where-Object { $_.Name -eq 'TargetUserName' }).'#text'
    $IpAddress      = ($XML.Event.EventData.Data | Where-Object { $_.Name -eq 'IpAddress' }).'#text'
    $LogonType      = ($XML.Event.EventData.Data | Where-Object { $_.Name -eq 'LogonType' }).'#text'

    # Sistem hesaplarini (MACHINE$) rapordan muaf tutalim
    if ($TargetUserName -notlike "*$") {
        [PSCustomObject]@{
            TimeCreated = $Event.TimeCreated
            Username    = $TargetUserName
            ClientIP    = $IpAddress
            LogonType   = $LogonType
        }
    }
}

# Raporu kurumsal paylasim alanina veya log sunucusuna cikti olarak veriyoruz
$Report | Format-Table -AutoSize
Write-Output "[SUCCESS] Saatlik AD denetim raporu basariyla uretildi."
