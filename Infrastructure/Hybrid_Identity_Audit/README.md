# Project Active-Auditor & Linux LDAP Hardening

## 📌 Modül Amacı
Bu modül, hibrid kurumsal altyapılarda (Windows Active Directory & Linux Ubuntu) kimlik doğrulama güvenliğini artırmayı ve iç denetim ekiplerinin anlık/saatlik izleme gereksinimlerini karşılamayı amaçlar.

---

## 📊 1. Active Directory Otomasyonu
* **`Get-SuccessLogonReport.ps1`**: Domain Controller sunucuları üzerinde son 1 saat içerisinde gerçekleşen başarılı oturum açma (Event ID 4624) işlemlerini analiz eder. Sistem hesaplarını temizleyerek gerçek kullanıcı hareketlerini raporlar.

## 🐧 2. Linux Enterprise Hardening
* **`ldap_secure_baseline.sh`**: Linux platformlarının kurumsal etki alanına (Domain) bağlanırken kullandığı SSSD katmanını sıkılaştırır. LDAP trafiğini TLS (LDAPS) kullanmaya zorlar. Yerel gruplardaki SID çakışmalarını bertaraf ederek kurumsal domain hesaplarını güvenli alt kırılımlarla (`sudoers.d`) yetkilendirir.

---
🌐 **Hybrid Infrastructure & Identity Management Framework**
