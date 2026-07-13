# 1. Müşteri Taleplerini Karşılayan HTTP Tabanlı Sipariş Servisi (API)
resource "azurerm_container_app" "siparis_api" {
  name                         = "siparis-servisi"
  container_app_environment_id = azurerm_container_app_environment.aca_env.id
  resource_group_name          = var.rg_name
  revision_mode                = "Single"

  template {
    container {
      name   = "siparis-api-container"
      image  = "mcr.microsoft.com/azuredocs/aci-helloworld:latest" # Test için hafif bir imaj
      cpu    = "0.25"
      memory = "0.5Gi"
    }

    # SİHİRLİ ÖLÇEKLEME: İstek gelmediğinde sunucuyu tamamen kapatır!
    min_replicas = 0
    max_replicas = 3
  }

  ingress {
    allow_insecure_connections = false
    external_enabled           = true # Dış dünyadan sipariş alabilmesi için trafiğe açtık
    target_port                = 80
    traffic_weight {
      percentage      = 100
      latest_revision = true
    }
  }
}

# 2. Arka Planda Kendi Halinde Çalışan Stok Servisi (Background Worker)
resource "azurerm_container_app" "stok_worker" {
  name                         = "stok-servisi"
  container_app_environment_id = azurerm_container_app_environment.aca_env.id
  resource_group_name          = var.rg_name
  revision_mode                = "Single"

  template {
    container {
      name   = "stok-worker-container"
      image  = "mcr.microsoft.com/azuredocs/aci-helloworld:latest"
      cpu    = "0.25"
      memory = "0.5Gi"
    }

    # Arka plan servisi olduğu için ve dışarıdan HTTP isteği almadığı için 
    # Sürekli 1 adet ayakta kalsın dedik (İsteğe göre bu da kuyruk doluluğuna göre sıfırlanabilir)
    min_replicas = 1
    max_replicas = 2
  }
}