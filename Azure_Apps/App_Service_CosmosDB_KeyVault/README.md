# Azure PaaS Altyapısı ve Kurumsal Veri Mimarisi Labı
## 🚀 App Service, Cosmos DB & Key Vault ile Güvenli Kurumsal Mimari (Terraform IaC)

Bu proje; kurumsal bulut standartlarında sunucu yönetimi (IaaS) yükünü tamamen ortadan kaldıran, kod ve veri odaklı modern bir **Azure PaaS (Platform as a Service)** mimarisinin Altyapı Kod Olarak (**IaC - Terraform**) inşa edilmesini içerir. 

Proje; siber güvenlik hardening protokollerini (**Key Vault Secrets Management**), küresel ölçekte veri katmanını (**Cosmos DB**) ve esnek Linux web barındırma modelini (**App Service**) tek bir güvenli ve entegre altyapıda birleştirir.

---

## 🗺️ Mimari Genel Bakış & Güvenlik Matrisi

Proje, kurumsal ortamlarda penetration test bulgularını (Açık bağlantı dizeleri, hardcoded şifreler) önlemek amacıyla **Zero Trust** felsefesine uygun olarak tasarlanmıştır. Uygulama katmanı, veri tabanı şifrelerine asla doğrudan erişemez; tüm hassas veriler Key Vault arkasında izole edilir.



### 🏗️ Kullanılan Azure Bileşenleri ve Detayları

| Kaynak Tipi | Azure Servis Adı | Yapılandırma / SKU / Detaylar | Güvenlik / Ölçekleme Rolü |
| :--- | :--- | :--- | :--- |
| **Resource Group** | `azurerm_resource_group` | `1-fbf104d2-playground-sandbox` | Lab sınırlandırma ve kaynak yönetimi. |
| **Web Infrastructure** | `azurerm_linux_web_app` | Service Plan: `Standard_B1` (.NET 8.0 / Node.js) | Esnek, auto-scale uyumlu web barındırma katmanı. |
| **NoSQL Data Layer** | `azurerm_cosmosdb_account` | API: `SQL (Core)`, Tutarlılık: `Session` | Küresel ölçeklenebilir, düşük gecikmeli veri tabanı. |
| **Security Vault** | `azurerm_key_vault` | SKU: `Standard`, Access Policies Enabled | Bağlantı dizelerinin (Connection Strings) sızmasını önleyen güvenli kasa. |

---

## ⚙️ Topoloji Detayları (Variables & Hardening)

* **Hedef Bölge (Region):** `southcentralus` (Güney Merkez ABD - Kararlı Kurumsal Politikalarla Uyumlu Bölge)
* **Secret Yönetimi:** Cosmos DB anahtarları (`primary_key`) ve endpoint bilgileri, Terraform dağıtımı esnasında otomatik olarak yakalanıp **Azure Key Vault Secret** olarak mühürlenir. Uygulama katmanı bu verileri çalışma zamanında (Runtime) güvenli çevre değişkenleri üzerinden çeker.

---

## 🚀 Kurulum ve Dağıtım Adımları

Lokal terminaliniz üzerinden Azure CLI (`az login`) ile sandbox hesabınıza giriş yaptıktan sonra, proje klasöründe sırasıyla şu Terraform operasyon zincirini işletin:

### 1. Altyapıyı Başlatma ve Sağlayıcı Kurulumu
Terraform sağlayıcılarını (AzureRM), kütüphanelerini ve state mekanizmasını initialize edin:
```bash
terraform init
```

### 2. Değişiklik Haritasının Doğrulanması (Planlama)

Mevcut Azure altyapısı ile kod arasındaki farkı analiz edin, oluşturulacak kaynakları ve bağımlılıkları doğrulayın:

```bash
terraform plan
``` 


### 3. Dağıtımın Canlı Ortama Fırlatılması (Execution)

Altyapıyı onay gerektirmeden, bağımlılık sırasına (Dependency Tree) göre doğrudan Azure bulutuna fırlatın:

```bash
terraform apply -auto-approve
```