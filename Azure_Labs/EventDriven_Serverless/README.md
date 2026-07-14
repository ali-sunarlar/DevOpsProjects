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


### Azure CLI üzerinden Kontroller

Terminalinden bu siber hattın durumunu sorgulamak için şu komutları koşturabilirsin:

#### 1. Service Bus Kuyruk detaylarını ve bekleyen mesaj sayısını terminale dök
az servicebus queue show \
  --resource-group "1-de0c7353-playground-sandbox" \
  --namespace-name "muhasebe-otomasyon-bus" \
  --name "siparis-kuyrugu" \
  --query "{Name:name, MessageCount:messageCount, SizeInBytes:sizeInBytes}" \
  --output table

#### 2. Azure Function App'in şu an çalışır (Running) durumda olup olmadığını kontrol et
az functionapp show \
  --resource-group "1-de0c7353-playground-sandbox" \
  --name "stok-guncelleyici-function" \
  --query "state" \
  --output tsv