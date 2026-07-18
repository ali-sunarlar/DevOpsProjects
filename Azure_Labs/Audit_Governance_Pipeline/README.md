# Kurumsal Denetim İzleri ve Güvenlik Analitiği Boru Hattı
## 🛡️ ISO 27001 ve BDDK Uyumlu Log Analytics & Diagnostic Settings (Terraform IaC)

Bu proje; kurumsal bulut ortamlarında yetkisiz erişimleri, hatalı konfigürasyon değişikliklerini ve veri sızıntısı (Data Exfiltration) girişimlerini anlık olarak tespit etmek amacıyla **Zero-Trust İzlenebilirlik (Observability)** hattını Altyapı Kod Olarak (**IaC - Terraform**) inşa eder.

---

## 🗺️ Siber İzleme Topolojisi

1. **Control Plane İzleme (Activity Log):** Azure platformu üzerinde yapılan kaynak silme, durdurma ve oluşturma hareketleri merkezi olarak takip edilir.
2. **Data Plane İzleme (Diagnostic Settings):** Kritik `Key Vault` gibi kaynakların içine girilerek gerçekleştirilen gizli şifre okuma (`AuditEvent`) gibi derinlemesine operasyonel hareketler, **Diagnostic Settings** köprüsü üzerinden **Log Analytics Workspace** havuzuna şifreli ve güvenli olarak pompalanır.

---

## ⚙️ Kurulum ve Dağıtım Adımları

```bash
terraform init
terraform plan
terraform apply -auto-approve
```



Adım 1: Kritik Kasaya Sızma Girişimi (Secret Yazma ve Okuma)

Öncelikle Terraform çıktısındaki veya portal üzerindeki güncel Key Vault adını ve kaynak grubunu kullanarak şu komutları koştur Ali. Bu hamle doğrudan kasada bir ``SecretWrite`` ve ``SecretGet`` operasyonu yaratacak:

```Bash
# 1. Kasaya kurumsal sahte bir şifre ekleyelim (Secret Write Tetiklemesi)
az keyvault secret set \
  --vault-name "kritik-kasa-c0eb" \
  --name "MuhasebeDBPassword" \
  --value "ZirhliSifre2026!"

# 2. Eklediğimiz şifreyi geri okuyalım (Secret Get / Read Tetiklemesi)
az keyvault secret show \
  --vault-name "kritik-kasa-c0eb" \
  --name "MuhasebeDBPassword"

```

Adım 2: Log Analytics Merkezini Sorgulama (CLI ile Log Avcılığı)

Çok Kritik Not: Azure altyapısında Diagnostic Settings üzerinden Log Analytics Workspace'e logların akması ve indekslenmesi (ilk tetikleme için) 5 ila 15 dakika arasında sürebilir. Komutu koşturduğunda hemen sonuç gelmezse panik yok, arkadaki siber boru hatlarının dolmasını bekliyoruz demektir.

Birkaç dakika sonra, bıraktığımız bu siber ayak izlerini terminalden KQL (Kusto Query Language) sorgusu atarak avlamak için şu CLI komutunu fırlat:
```Bash
az monitor log-analytics query \
  --workspace "sirket-siber-analiz-merkezi" \
  --analytics-query "AzureDiagnostics | where ResourceProvider == 'MICROSOFT.KEYVAULT' | project TimeGenerated, OperationName, ResultType, CallerIPAddress" \
  --output table
```