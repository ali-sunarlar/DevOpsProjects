# Azure Service Bus & Functions ile Event-Driven Serverless Altyapı
## ⚡ decoupled (Gevşek Bağlı) ve Sıfır Sunucu Maliyetli Mimari (Terraform IaC)

Bu proje; kurumsal e-ticaret sistemlerindeki sipariş alma ve stok düşme süreçlerini birbirinden tamamen bağımsız hale getiren (decoupling) asenkron, olay güdümlü (**Event-Driven**) ve sunucusuz (**Serverless FaaS**) bir bulut mimarisini Altyapı Kod Olarak (**IaC - Terraform**) inşa eder.

---

## 🗺️ Mimari Akış ve Güvenlik Gücü

Sipariş API'si, doğrudan stok veritabanına gidip sistemi kilitlemek yerine sipariş verisini saniyeler içinde **Service Bus Queue** katmanına fırlatır ve müşteriye "Siparişiniz Alındı" yanıtını döner.

1. **Gevşek Bağlılık (Decoupling):** Stok servisi kapalı bile olsa siparişler kuyrukta güvenle bekler (Sistem asla çökmez).
2. **Event-Driven Serverless:** Azure Function, kuyruğu sürekli dinlemez. Kuyruğa yeni bir mesaj düştüğü an **KEDA** tabanlı tetikleyici tarafından uyandırılır, mesajı işler ve ardından instance sayısını otomatik olarak **0'a** çekerek şirkete fatura üretilmesini engeller.

---

## ⚙️ Kurulum ve Dağıtım Adımları

```bash
# 1. Projeyi başlatın
terraform init

# 2. Yapıyı planlayın
terraform plan

# 3. Canlıya fırlatın
terraform apply -auto-approve
```