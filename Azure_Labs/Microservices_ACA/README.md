# Azure Container Apps (ACA) ile Sunucusuz Mikroservis Mimarisi
## 🐳 Kubernetes Karmaşası Olmadan Event-Driven Konteyner Yönetimi (Terraform IaC)

Bu proje; kurumsal e-ticaret altyapılarında geleneksel Kubernetes (AKS) kümesi yönetiminin getirdiği hantallık, YAML yoğunluğu ve yüksek node maliyetlerini ortadan kaldıran modern bir **Serverless Konteyner** mimarisinin Altyapı Kod Olarak (**IaC - Terraform**) inşa edilmesini içerir.

Proje; HTTP tabanlı dışa açık bir API servisinin (**Sipariş Servisi**) ve arka planda izole çalışan bir worker mekanizmasının (**Stok Servisi**), ortak bir siber yaşam alanında güvenle çalışmasını ve anlık yüklere göre otomatik esnemesini sağlar.

---

## 🗺️ Mimari Tasarım ve Akıllı Ölçekleme (KEDA)

Bu altyapının en kritik kurumsal özelliği, şirket bütçesini korumak amacıyla kurgulanan **Scale-to-Zero (Sıfıra Ölçekleme)** stratejisidir.

* **Sipariş Servisi (HTTP API):** Dış dünyadan (Ingress) talep alan bu servis, geceleri veya hiç trafik gelmediği anlarda konteyner instance sayısını dinamik olarak **0 (Sıfır)** seviyesine çeker. Sabah yoğunluğu başladığında veya ilk istek geldiğinde, arkadaki **KEDA** motoru tetiklenerek konteyner milisaniyeler içinde ayağa kaldırılır.
* **Stok Servisi (Background Worker):** Herhangi bir dış trafiğe (HTTP) kapalıdır. Tamamen iç ağda ve arka planda kuyrukları/stokları dinleyecek şekilde sürekli en az **1 Instance** aktif kalacak şekilde zırhlanmıştır.

### 🏗️ Altyapı Bileşen Matrisi

| Kaynak Tipi | Azure Servis Adı | Yapılandırma / Karakteristik | Rolü ve Amacı |
| :--- | :--- | :--- | :--- |
| **Merkezi Log Deposudur** | `azurerm_log_analytics_workspace` | SKU: `PerGB2018`, 30 Gün Saklama | Tüm mikroservislerin stdout/stderr loglarını tek merkezde toplar. |
| **Ortak Yaşam Alanı** | `azurerm_container_app_environment` | `sirket-microservices-env` | Mikroservis sınırını, ortak siber ağı ve log altyapısını belirler. |
| **Sipariş Mikroservisi** | `azurerm_container_app` (Sipariş) | Replicas: `0 - 3`, External Ingress: `On` | Müşteri sepet ve sipariş taleplerini karşılayan akıllı API. |
| **Stok Mikroservisi** | `azurerm_container_app` (Stok) | Replicas: `1 - 2`, External Ingress: `Off` | Arka planda deponun durumunu güncelleyen izole worker. |

---

## ⚙️ Değişken ve Parametre Yönetimi

Proje, hardcoded (statik) değerlerden tamamen arındırılmıştır ve çoklu ortam (Dev/Prod) geçişlerine uygundur:

* **`variables.tf`:** Kullanılacak parametrelerin tip tanımlamalarını içerir.
* **`terraform.tfvars`:** Her lab oturumunda değişen dinamik kaynak grubu ve lokasyon bilgisini tek merkezden yönetir:
  ```hcl
  rg_name  = "1-508cbdb2-playground-sandbox"
  location = "southcentralus"

🚀 Kurulum ve Dağıtım Adımları

Lokal terminaliniz üzerinden Azure CLI ile sandbox hesabına giriş yaptıktan sonra proje klasöründe sırasıyla şu komutları işletin:


```Bash
# 1. Terraform sağlayıcılarını ve kütüphanelerini initialize edin
terraform init

# 2. Değişiklik haritasını ve oluşturulacak mikroservisleri planlayın
terraform plan

# 3. Mikroservis fabrikasını doğrudan Azure bulutuna fırlatın
terraform apply -auto-approve
```