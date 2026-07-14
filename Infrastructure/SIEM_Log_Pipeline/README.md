# Project Log-Watch & SIEM Pipeline

## 📌 Modül Amacı
Bu modül, kurumsal Linux sunucu bloklarında koşan kritik servislerin loglarını ve admin hareketlerini kernel seviyesinde denetlemeyi, optimize etmeyi ve merkezi SIEM altyapısına (Elasticsearch/Graylog/Splunk) güvenli bir şekilde aktarmayı amaçlar.

---

## ⚡ 1. Fluent Bit ile Hafif ve Akıllı Log Süzme (`fluent_bit/`)
* **`parsers_and_filter.conf`**: Ham syslog ve `auth.log` verilerini gerçek zamanlı tarar. Regex filtreleri sayesinde sadece **SSH Login Hatalarını**, **Başarılı SSH Anahtar Girişlerini** ve **Sudo Yetki Kullanımlarını** süzerek SIEM limitlerini korur. Gereksiz log gürültüsünü %90 oranında azaltır.

## 🛡️ 2. Kernel Seviyesinde Auditd Kuralları (`auditd_rules/`)
* **`audit.rules`**: Linux çekirdeği (Kernel) seviyesinde çalışır. 
    * `/etc/shadow` ve `/etc/sudoers` gibi kritik dosyaların kimler tarafından değiştirildiğini raporlar.
    * `sudo` ile tetiklenen tüm yetki yükseltme işlemlerini (`execve`) kayıt altına alır ve SIEM alarm paneline etiketli (`priv_esc`, `identity`) veri besler.

---
🌐 **Siber Güvenlik, Log Standardizasyonu ve SIEM Entegrasyonu Modülü**
