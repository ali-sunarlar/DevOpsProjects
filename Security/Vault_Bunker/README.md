# Project Vault-Bunker (Dynamic Secret Management & Rotation)

## 📌 Modül Amacı
Bu modül, kurumsal uygulamaların ve veri tabanlarının statik şifre bağımlılıklarını ortadan kaldırmak, siber güvenlik uyumluluğunu (PCI-DSS / ISO 27001) sağlamak ve HashiCorp Vault entegrasyonunu yönetmek amacıyla geliştirilmiştir. Dinamik Azure altyapıları ve hem Linux (Distrobox/Fedora Silverblue) hem de Windows ortamlarında hibrit çalışabilecek çapraz platform otomasyon standartlarını barındırır.

---

## 🔐 1. Aşama: Kasa Erişim Politikası (`vault_policies/app-readonly-policy.hcl`)

*Least Privilege* (En Düşük Yetki) prensibine uygun olarak, uygulamaların sadece kendilerine ait gizli verilere salt okunur erişimini sağlar.

```hcl
# vault_policies/app-readonly-policy.hcl
path "secret/data/production/database" {
  capabilities = ["read"]
}

path "secret/metadata/production/database" {
  capabilities = ["read", "list"]
}
```


🔄 2. Aşama: Çapraz Platform Şifre Döndürme Otomasyonu (rotation_scripts/Rotate-DatabaseSecret.ps1)

Zamanlanmış bir görev (CronJob/Azure Automation) olarak çalışır. Windows .NET bağımlılıklarından (System.Web) arındırılmış bu akıllı betik, parolayı rastgele yeniden üretir, hedef DB'de günceller ve Vault API'sini tetikleyerek şifreyi canlı olarak yeniler.
```PowerShell

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
```

🏗️ 3. Aşama: Azure AKS & Vault Lab Dağıtım ve Test Adımları
🛠️ Adım 3.1: Dinamik Sandbox Grubu Tespiti & AKS v2 Kurulumu

Değişen sandbox isimlerine karşı altyapıyı dinamik hale getirip hafif (Standard_B2s) cluster mimarisini ayağa kaldırıyoruz:
```Bash

# Aktif kaynak grubunu tespit et ve değişkene kilitle
export AZ_RG=$(az group list --query "[0].name" -o tsv)

# Standart public API endpoint yetenekleriyle AKS kümesini tetikleyelim
az aks create \
  --resource-group $AZ_RG \
  --name hydra-aks-v2 \
  --node-count 2 \
  --node-vm-size Standard_B2s \
  --generate-ssh-keys
```

🔑 Adım 3.2: Kimlik Bilgilerini Çekme & Düğüm Kontrolü
```Bash

# Küme anahtarlarını yerel context'e bağlama (Public FQDN zorlaması olmadan standart bağlantı)
az aks get-credentials --resource-group $AZ_RG --name hydra-aks-v2 --overwrite-existing

# Bağlantıyı test etme
kubectl get nodes
```


📦 Adım 3.3: Distrobox Ortam Hazırlığı (Bağımlılıkların Çözülmesi)

Fedora minimal imaj kullanan Distrobox container'larda eksik araçları ve pwsh motorunu kurmak için:
```Bash

# 1. openssl ve dnf depolarını tazeleyelim
sudo dnf install -y openssl

# 2. Microsoft reposunu ekleyip PowerShell Core yükleyelim
sudo rpm --import [https://packages.microsoft.com/keys/microsoft.asc](https://packages.microsoft.com/keys/microsoft.asc)
sudo curl -o /etc/yum.repos.d/microsoft.repo [https://packages.microsoft.com/config/rhel/9/prod.repo](https://packages.microsoft.com/config/rhel/9/prod.repo)
sudo dnf install -y powershell
```

🚀 Adım 3.4: Helm ile Vault Veri Kasasını Konumlandırma
```Bash

# İzole yönetim alanını açalım
kubectl create namespace vault-system

# Vault'u hafif Dev modunda kümeye üfleyelim
helm install vault hashicorp/vault \
  --namespace vault-system \
  --set "server.dev.enabled=true"
```

🔀 Adım 3.5: Güvenli Tünel ve Rotasyon Motorunun Ateşlenmesi
```Bash

# 1. Yerel 8200 portundan Azure AKS'e tünel açalım
kubectl port-forward svc/vault 8200:8200 -n vault-system &

# 2. Least-Privilege politikasını enjekte edelim
kubectl cp vault_policies/app-readonly-policy.hcl vault-system/vault-0:/tmp/policy.hcl
kubectl exec -n vault-system -it vault-0 -- vault policy write app-readonly /tmp/policy.hcl

# 3. Dev modu varsayılan root tokenını ("root") çevre değişkenine bağlayıp betiği koşturma
export VAULT_ROTATOR_TOKEN="root"
pwsh ./rotation_scripts/Rotate-DatabaseSecret.ps1

```

🎯 Adım 3.6: Canlı Veri ve Versiyon Doğrulama
```Bash

# Kasaya şifrenin başarıyla oturup oturmadığını ve versiyonlandığını izleme
kubectl exec -n vault-system -it vault-0 -- vault kv get secret/production/database

```