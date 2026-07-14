# 1. Service Bus Ana Sunucusu (Namespace)
resource "azurerm_servicebus_namespace" "sb_namespace" {
  name                = "muhasebe-otomasyon-bus"
  location            = var.location
  resource_group_name = var.rg_name
  sku                 = "Standard" 
}

# 2. Siparişlerin Akacağı Siber Kuyruk (Queue)
resource "azurerm_servicebus_queue" "order_queue" {
  name         = "siparis-kuyrugu"
  namespace_id = azurerm_servicebus_namespace.sb_namespace.id

  # SİHİRLİ DOKUNUŞ: enable_partitioning yerine partitioning_enabled yazıyoruz
  partitioning_enabled = false 
  max_size_in_megabytes = 1024
}