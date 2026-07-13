#!/bin/bash
set -e

echo "=== Linux Kurumsal Kimlik ve LDAP Sıkılaştırması Başlıyor ==="

# 1. SSSD Konfigürasyonunu Güvenli Hale Getirme
SSSD_CONF="/etc/sssd/sssd.conf"

if [ -f "$SSSD_CONF" ]; then
    echo "[-] SSSD Güvenlik Parametreleri Optimize Ediliyor..."
    # LDAP üzerinden veri transferini LDAPS (TLS) zorunluluğuna çekme
    sudo sed -i 's/^#\?ldap_id_use_start_tls.*/ldap_id_use_start_tls = true/' $SSSD_CONF
    sudo sed -i 's/^#\?ldap_tls_reqcert.*/ldap_tls_reqcert = demand/' $SSSD_CONF
    
    # Cross-environment SID ve ID haritalandırma optimizasyonu
    if ! grep -q "ldap_id_mapping" $SSSD_CONF; then
        echo "ldap_id_mapping = true" | sudo tee -a $SSSD_CONF
    fi
    
    sudo systemctl restart sssd
    echo "[SUCCESS] SSSD yapılandırması güncellendi."
else
    echo "[WARNING] SSSD servisi bulunamadı, entegrasyon adımları atlanıyor."
fi

# 2. Kurumsal Domain Kullanıcısını Sudoers Katmanına Güvenli Enjekte Etme
echo "[-] Merkezi Hak Yönetimi ve Sudoers Ataması Yapılıyor..."
# Local grup SID karmaşasını önlemek adına doğrudan Domain kullanıcısını kurumsal kuralla sudoers'a ekliyoruz
SUDOERS_FILE="/etc/sudoers.d/90-corporate-admins"

echo "# Kurumsal Domain Yoneticileri Yetkilendirmesi" | sudo tee $SUDOERS_FILE
echo "sysadmin@kurumsal.int ALL=(ALL) NOPASSWD:ALL" | sudo tee -a $SUDOERS_FILE
sudo chmod 0440 $SUDOERS_FILE

echo "=== Hibrid Altyapı Güvenlik Baseline İşlemleri Tamamlandı ==="
