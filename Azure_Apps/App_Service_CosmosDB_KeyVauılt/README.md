# Azure PaaS Altyapısı ve Kurumsal Veri Mimarisi Labı
## (App Service, Cosmos DB & Key Vault - Terraform IaC)

Bu proje; sunucu yönetimi yükünü (IaaS) tamamen ortadan kaldıran, kod ve veri odaklı modern bir **Azure PaaS (Platform as a Service)** mimarisinin Altyapı Kod Olarak (IaC - Terraform) inşa edilmesini içerir.

Proje, kurumsal bulut standartlarında siber güvenliği (Key Vault), küresel ölçekte veri katmanını (Cosmos DB) ve esnek web barındırma modelini (App Service) tek bir entegre mimaride birleştirir.

---

## 🛠️ Mimari Bileşenler & Kaynaklar

* **Web Altyapısı:** Azure Linux App Service (`Standard_B1` Plan) -> .NET 8.0/Node.js uyumlu.
* **NoSQL Veri Katmanı:** Azure Cosmos DB (SQL/Core API) -> `Session` tutarlılık modeliyle küresel ölçekleme.
* **Siber Güvenlik Kasası:** Azure Key Vault (`Standard` SKU) -> Şifrelerin ve bağlantı dizelerinin sızmasını önleyen güvenli kasa.
* **Bölge (Region):** `southcentralus` (Güney Merkez ABD - Kararlı & Politika Uyumlu Bölge)
* **Kaynak Grubu (Resource Group):** `1-fbf104d2-playground-sandbox`

---

## 🚀 Kurulum ve Dağıtım Adımları

Lokal terminaliniz üzerinden Azure CLI ile sandbox hesabına giriş yaptıktan sonra proje klasöründe sırasıyla şu komutları işletin:

```bash
# 1. Terraform sağlayıcılarını ve kütüphanelerini initialize edin
terraform init

# 2. Değişiklik haritasını ve oluşturulacak kaynakları doğrulayın
terraform plan

# 3. Altyapıyı onay gerektirmeden doğrudan Azure bulutuna fırlatın
terraform apply -auto-approve
```


