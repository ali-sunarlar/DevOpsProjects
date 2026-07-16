# 1. Traffic Manager Profili
resource "azurerm_traffic_manager_profile" "tm_profile" {
  name                   = "ali-global-router" # Global benzersiz olmalı
  resource_group_name    = var.rg_name
  traffic_routing_method = "Priority" # Karar verdiğimiz gibi Priority!

  dns_config {
    relative_name = "ali-global-router"
    ttl           = 30 # DNS önbelleğinin hızlı yenilenmesi için 30 saniye
  }

  monitor_config {
    protocol                     = "HTTPS"
    port                         = 443
    path                         = "/"
    interval_in_seconds          = 10 # Her 10 saniyede bir bölgeleri kontrol et
    timeout_in_seconds           = 5
    tolerated_number_of_failures = 2  # Üst üste 2 kez hata alırsan o bölgeyi pasif yap
  }
}

# 2. Birincil Uç Nokta (Primary Endpoint - Priority 1)
resource "azurerm_traffic_manager_azure_endpoint" "primary_endpoint" {
  name               = "primary-endpoint-us"
  profile_id         = azurerm_traffic_manager_profile.tm_profile.id
  target_resource_id = azurerm_linux_web_app.primary_web.id
  weight             = 100
  priority           = 1 # En yüksek öncelik!
}

# 3. İkincil Uç Nokta (Secondary Endpoint - Priority 2)
resource "azurerm_traffic_manager_azure_endpoint" "secondary_endpoint" {
  name               = "secondary-endpoint-eu"
  profile_id         = azurerm_traffic_manager_profile.tm_profile.id
  target_resource_id = azurerm_linux_web_app.secondary_web.id
  weight             = 100
  priority           = 2 # Yedek öncelik!
}