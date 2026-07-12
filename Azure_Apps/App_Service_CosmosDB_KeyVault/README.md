# Azure PaaS Altyapisi ve Kurumsal Veri Mimarisi Labi
## 🚀 App Service, Cosmos DB & Key Vault ile Güvenli Kurumsal Mimari (Terraform IaC)

Bu proje; kurumsal bulut standartlarinda sunucu yönetimi (IaaS) yükünü tamamen ortadan kaldiran, kod ve veri odakli modern bir **Azure PaaS (Platform as a Service)** mimarisinin Altyapi Kod Olarak (**IaC - Terraform**) inşa edilmesini içerir. 

kurumsal bulut standartlarinda sunucu yönetimi (IaaS) yükünü tamamen ortadan kaldiran, kod ve veri odakli modern bir **Azure PaaS (Platform as a Service)** mimarisinin Altyapi Kod Olarak (**IaC - Terraform**) inşa edilmesini içerir. 

kurumsal bulut standartlarinda sunucu yönetimi (IaaS) yükünü tamamen ortadan kaldiran, kod ve veri odakli modern bir **Azure PaaS (Platform as a Service)** mimarisinin Altyapi Kod Olarak (**IaC - Terraform**) inşa edilmesini içerir. 

---

## 🗺️ Mimari Genel Bakiş & Güvenlik Matrisi

Proje, kurumsal ortamlarda penetration test bulgularini (Açik bağlanti dizeleri, hardcoded şifreler) önlemek amaciyla **Zero Trust** felsefesine uygun olarak tasarlanmiştir. Uygulama katmani, veri tabani şifrelerine asla doğrudan erişemez; tüm hassas veriler Key Vault arkasinda izole edilir.

* **Kimlik Zirhi:** Web App, **System-Assigned Managed Identity** kullanarak Azure Entra ID üzerinde şifresiz bir siber kimliğe kavuşur.
* **Ağ Zirhi:** Key Vault ve Cosmos DB servislerinin kamusal internet kapilari mühürlenmiştir. Servisler, **Private Endpoint** teknolojisi ile sanal ağ (VNet) içerisinde yerel IP'lere (`10.0.1.x`) dönüştürülmüştür. Web App ise **VNet Integration** köprüsüyle bu izole ağin içine gömülmüştür.


### 🏗️ Kullanilan Azure Bileşenleri ve Detaylari

| Kaynak Tipi | Azure Servis Adi | Yapilandirma / SKU / Detaylar | Güvenlik / Ölçekleme Rolü |
| :--- | :--- | :--- | :--- |
| **Dinamik RG** | `azurerm_resource_group` | `.tfvars` üzerinden beslenir | Lab değişimlerinde tek merkezden yönetim. |
| **Web Infrastructure** | `azurerm_linux_web_app` | Service Plan: `B1` (Linux / .NET 8.0) | VNet Integration entegreli, şifresiz kimlikli web katmani. |
| **NoSQL Data Layer** | `azurerm_cosmosdb_account` | API: `SQL (Core)`, Tutarlilik: `Session` | Küresel ölçeklenebilir, düşük gecikmeli izole veri tabani. |
| **Security Vault** | `azurerm_key_vault` | SKU: `Standard`, `random_id` Suffix | Küresel isim çakişmalarini (`VaultAlreadyExists`) engelleyen dinamik kasa. |
| **Sanal Ağ (VNet)** | `azurerm_virtual_network` | `10.0.0.0/16` (2 Subnet ayrilmiş) | Tüm PaaS dünyasini internetten koparip gömdüğümüz siber kale. |

---

## ⚙️ Topoloji Detaylari (Variables & Hardening)

* **Hedef Bölge (Region):** `southcentralus` (Güney Merkez ABD - Kararli Kurumsal Politikalarla Uyumlu Bölge)
* **Secret Yönetimi:** Cosmos DB anahtarlari (`primary_key`) ve endpoint bilgileri, Terraform dağitimi esnasinda otomatik olarak yakalanip **Azure Key Vault Secret** olarak mühürlenir. Uygulama katmani bu verileri çalişma zamaninda (Runtime) güvenli çevre değişkenleri üzerinden çeker.

---

## ⚙️ Dinamik Topoloji Yönetimi (Variables & Parametreler)

Proje, hardcoded (statik) değerlerden tamamen arindirilmiştir. Lab ortamlarinda sürekli değişen kaynak grubu adlari ve bölgeler için **Merkezi Değişken Mimarisi** kullanilir.

* **Parametre Yönetimi (`terraform.tfvars`):** Lab her değiştiğinde sadece bu dosya güncellenir:
  ```hcl
  rg_name  = "1-508cbdb2-playground-sandbox"
  location = "southcentralus"

## 🚀 Kurulum ve Dağitim Adimlari

Lokal terminaliniz üzerinden Azure CLI (`az login`) ile sandbox hesabiniza giriş yaptiktan sonra, proje klasöründe sirasiyla şu Terraform operasyon zincirini işletin:

### 1. Altyapiyi Başlatma ve Sağlayici Kurulumu
Terraform sağlayicilarini (AzureRM, Random), kütüphanelerini ve state mekanizmasini initialize edin:
```bash
# Eski lab state kalintilari varsa temizleyin
rm -f terraform.tfstate terraform.tfstate.backup

# Projeyi başlatin
terraform init
```

### 2. Değişiklik Haritasinin Doğrulanmasi (Planlama)

Merkezi ``terraform.tfvars`` dosyasindaki güncel lab parametrelerine göre altyapi bağimlilik ağacini doğrulayin:

```bash
terraform plan
``` 


### 3. Dağitimin Canli Ortama Firlatilmasi (Execution)

Altyapiyi onay gerektirmeden, bağimlilik sirasina (Dependency Tree) göre doğrudan Azure bulutuna firlatin:

```bash
terraform apply -auto-approve
```