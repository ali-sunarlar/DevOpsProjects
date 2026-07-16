# Multi-Region Active-Passive Disaster Recovery Architecture
## 🌍 Global Traffic Manager & Automated Failover (Terraform IaC)

Bu proje; kurumsal bir e-ticaret altyapısını bölgesel kesintilere karşı korumak amacıyla iki farklı coğrafi bölgede (US ve EU) yedekli olarak ayağa kaldıran ve **Azure Traffic Manager (Priority Routing)** ile otomatik felaket kurtarma (**automated failover**) senaryosunu işleten küresel bir bulut mimarisini simüle eder.

---

## 🗺️ Mimari Akış ve Kararlılık Kuralları

1. **Normal Durum (Active):** Global kullanıcı istekleri `ali-global-router.trafficmanager.net` adresine gelir. Traffic Manager, **Priority 1** olan South Central US bölgesindeki App Service'i aktif tutar ve tüm yükü oraya yönlendirir.
2. **Afet Durumu (Passive Failover):** US bölgesinde bir kesinti algılandığında (10 saniyelik health check aralıklarıyla), Traffic Manager bu bölgeyi otomatik olarak devre dışı bırakır ve trafiği saniyeler içinde kayıpsız bir şekilde **Priority 2** olan North Europe bölgesine aktarır.

---

## ⚙️ Kurulum ve Dağıtım Adımları

```bash
terraform init
terraform plan
terraform apply -auto-approve
```

Traffic Manager Profilinin ve Endpoint'lerin Sağlığını Sorgulama

Her iki bölgenin aktiflik ve sağlık durumunu tek bir komutla tablo halinde listele:
```bash
az network traffic-manager endpoint list \
  --resource-group "1-a0672365-playground-sandbox" \
  --profile-name "ali-global-router" \
  --query "[].{Name:name, Priority:priority, Status:endpointMonitorStatus}" \
  --output table
```


Web Uygulamasını CLI ile Kapatıp Açarak Failover Testi

Portala hiç girmeden sadece CLI üzerinden birincil bölgeyi çökertip ayağa kaldırarak failover testini gerçekleştirebilirsin:
```Bash
# 1. Birincil Web Uygulamasını kapat (Felaket anı!)
az webapp stop \
  --resource-group "1-c4d84f51-playground-sandbox" \
  --name "ali-ecommerce-primary-us"

# 2. DNS sorgusunun saniyeler içinde yedek bölgeye kaydığını doğrulamak için curl at
curl -I http://ali-global-router.trafficmanager.net

# 3. Test bitince sistemi eski sağlıklı haline getirmek için uygulamayı geri başlat
az webapp start \
  --resource-group "1-c4d84f51-playground-sandbox" \
  --name "ali-ecommerce-primary-us"
  ```