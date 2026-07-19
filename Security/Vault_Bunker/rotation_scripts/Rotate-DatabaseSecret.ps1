# rotation_scripts/Rotate-DatabaseSecret.ps1
$VaultUrl = "[http://127.0.0.1:8200](http://127.0.0.1:8200)"
$VaultToken = $env:VAULT_ROTATOR_TOKEN$SecretPath = "v1/secret/data/production/database"

Write-Output "[*] Güvenli şifre döndürme (Secret Rotation) işlemi başlatıldı..."

# Linux (Distrobox) ve Windows uyumlu safkan PowerShell rastgele şifre üretici
$CharacterPool = "abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789!@#"
$NewPassword = -join ((1..24) | ForEach-Object { $CharacterPool[(Get-Random -Maximum$CharacterPool.Length)] })

Write-Output "[+] Yeni güvenli parola üretildi."
Write-Output "[*] Hedef veri tabanı üzerinde kullanıcı parolası güncellendi (Simüle)."

$Headers = @{
    "X-Vault-Token" = $VaultToken
    "Content-Type"  = "application/json"
}

$Payload = @{
    data = @{
        username = "prod_app_user"
        password = $NewPassword
        rotated_at = (Get-Date -Format "yyyy-MM-dd HH:mm:ss")
    }
} | ConvertTo-Json

try {
    $Response = Invoke-RestMethod -Uri "$VaultUrl/$SecretPath" -Method Post -Headers $Headers -Body$Payload
    Write-Output "[SUCCESS] Vault kasası başarıyla güncellendi! Yeni şifre versiyonu devrede."
} catch {
    Write-Error "[CRITICAL] Vault şifre güncellemesi başarısız oldu! Hata: $_"
    Exit 1
}