# Project Hydra-Sync (DR & Cross-Region Failover)

## 📌 Modül Amacı
Bu modül, kurumsal uygulamaların coğrafi kesintilere (Bölgesel datacenter çökmeleri) karşı dayanıklılığını artırmak amacıyla tasarlanmıştır. Gerçek zamanlı veri senkronizasyonu ve otomatik trafik yönlendirme mekanizmalarını yönetir.

---

## 🔄 1. Redis Sentinel Yüksek Erişilebilirlik (`redis_replication/`)
* **`sentinel.conf`**: İki bölge arasındaki Redis düğümlerini sürekli izler. Birincil düğümün (Master) çöktüğünü 5 saniye içinde tespit ederek otomatik oylama (Quorum) başlatır ve replica durumundaki DR düğümünü yeni Master olarak ilan eder (**Automatic Promotion**).

## 🔀 2. Trafik Yönlendirme ve Failover Otomasyonu (`failover_automation/`)
* **`Route-TrafficToDR.ps1`**: Birincil veri merkezindeki kritik veri katmanının sağlık durumunu TCP seviyesinde yoklar. Kesinti kesinleştiği an (3 başarısız deneme), DNS yönlendirmelerini (Azure Traffic Manager) tetikleyerek kullanıcı trafiğini milisaniyeler içinde kurtarma merkezine (DR Bölgesi) yönlendirir.

---
🌐 **Disaster Recovery & Business Continuity (BCDR) Engineering Module**
