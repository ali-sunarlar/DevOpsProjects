# 1. Service Bus Ana Sunucusu (Namespace) - Basic olarak güncellendi
resource "azurerm_servicebus_namespace" "sb_namespace" {
  name                = "muhasebe-otomasyon-bus"
  location            = var.location
  resource_group_name = var.rg_name
  sku                 = "Basic" # Standard yerine Basic yapıldı
}

# 2. Siparişlerin Akacağı Siber Kuyruk (Queue)
resource "azurerm_servicebus_queue" "order_queue" {
  name         = "siparis-kuyrugu"
  namespace_id = azurerm_servicebus_namespace.sb_namespace.id

  # Not: Basic SKU'da partitioning desteklenmeyebilir, bu satırı tamamen siliyoruz veya false bırakıyoruz.
  # Garanti olması için bu parametreyi kaldırıp sade bir kuyruk tanımı bırakalım:
  max_size_in_megabytes = 1024
}