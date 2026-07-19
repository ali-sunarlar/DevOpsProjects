# Vault Kurumsal Erişim Politikası - Least Privilege Prensibi

# Uygulamanın sadece kendi prod şifrelerini okuma izni var
path "secret/data/production/database" {
  capabilities = ["read"]
}

# Metadata kontrol izni (Versiyon takibi için)
path "secret/metadata/production/database" {
  capabilities = ["read", "list"]
}

# Diğer hiçbir gizli dizine (IK, Finans vb.) erişim izni verilmemiştir.
