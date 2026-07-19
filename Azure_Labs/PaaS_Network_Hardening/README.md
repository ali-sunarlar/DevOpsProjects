# Azure Service Endpoints ile PaaS Network Hardening Blueprints
## 🛡️ Veri Sızıntısını Önleyen (Data Exfiltration Prevention) Zero-Trust Altyapı

Bu proje; kurumsal finansal verileri barındıran bir `Storage Account` (Blob Storage) kaynağını public internet üzerindeki tüm siber tehditlere karşı tamamen kapatıp, yalnızca şirket içi güvenli bir alt ağdan (**Subnet**) erişilebilir hale getiren modern bir ağ zırhlama mimarisini (**Terraform IaC**) inşa eder.

---

## 🗺️ Siber Güvenlik Mimarisi

1. **İnternet Blokajı (`default_action = "Deny"`):** Kasanın bağlantı dizesi sızdırılsa bile, internetteki herhangi bir dış istemci/hacker bu depoya erişmeye çalıştığında doğrudan Firewall engeline takılır.
2. **Hızlı ve Güvenli Erişim (Service Endpoints):** `finans-islem-subnet` alt ağındaki kaynaklar, Storage Account ile konuşurken internet trafiğini kullanmaz; tamamen Azure'ın omurga ağı (Microsoft Backbone) üzerinden siber tünelle hedefe ulaşır.