# Project Cloud-Shield & FinOps Control

## 📌 Proje Amacı
Bu modül, kurumsal bulut altyapısında siber güvenlik standartlarının tam otomasyonla işletilmesini (**CISO Baseline**) ve bulut harcamalarının dinamik olarak optimize edilmesini (**CFO FinOps Baseline**) hedefler.

---

## 🔒 1. Cloud Governance (Azure Policy as Code)
Aşağıdaki politikalar, Azure Resource Manager (ARM) katmanında istekleri daha kaynak oluşturulmadan keser ve kurallara uymayan talepleri reddeder (**Deny Effect**):

* **`deny-public-ip.json`**: Ağ katmanında dışarıya doğrudan açık Public IP oluşturulmasını engeller.
* **`allowed-locations.json`**: Kaynakların yalnızca `westeurope` ve `northeurope` bölgelerinde ayağa kaldırılmasına izin verir.

---

## 💰 2. FinOps & Tagging Automation
Maliyet takibini ve tasarrufunu otomatize eden sunucusuz betikler:

* **`Find-UntaggedResources.ps1`**: `Environment`, `Owner` ve `CostCenter` etiketlerinden biri bile eksik olan kaynakları tarar ve siber-güvenlik/finans takibi için alarm üretir.
* **`Stop-DevEnvironments.ps1`**: Geliştirme ortamındaki VM'leri mesai saatleri dışında (Geceleri ve Hafta sonu) otomatik olarak kapatarak fatura maliyetlerini %60'a varan oranda düşürür.

---
🌐 **Cloud Infrastructure & Governance Team Core Module**
