# 1. Azure Function'ın çalışması için zorunlu olan depolama alanı (Storage Account)
resource "azurerm_storage_account" "func_storage" {
  name                     = "alifuncstorage" # Küçük harf ve rakam olmalı, global benzersiz olmalı
  resource_group_name      = var.rg_name
  location                 = var.location
  account_tier             = "Standard"
  account_replication_type = "LRS"
}

# 2. Sunucusuz (Consumption / Serverless) Plan
resource "azurerm_service_plan" "consumption_plan" {
  name                = "serverless-consumption-plan"
  resource_group_name = var.rg_name
  location            = var.location
  os_type             = "Linux"
  sku_name            = "Y1" # Y1 = Serverless Consumption SKU (Sıfır maliyetli tetikleyici)
}

# 3. Linux Function App (Kuyruğu dinleyecek ana siber ajan)
resource "azurerm_linux_function_app" "stok_function" {
  name                = "stok-guncelleyici-function"
  resource_group_name = var.rg_name
  location            = var.location

  storage_account_name       = azurerm_storage_account.func_storage.name
  storage_account_access_key = azurerm_storage_account.func_storage.primary_access_key
  service_plan_id            = azurerm_service_plan.consumption_plan.id

  site_config {
    application_stack {
      dotnet_version = "6.0" # Veya node_version, python_version seçilebilir
    }
  }

  app_settings = {
    # Function App'in Service Bus kuyruğunu dinlemesini sağlayan bağlantı dizesi:
    "ServiceBusConnection" = azurerm_servicebus_namespace.sb_namespace.default_primary_connection_string
  }
}