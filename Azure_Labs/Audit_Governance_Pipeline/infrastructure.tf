# 1. Tüm Siber Logların Toplanacağı Kara Kutu (Log Analytics Workspace)
resource "azurerm_log_analytics_workspace" "audit_center" {
  name                = "sirket-siber-analiz-merkezi"
  location            = var.location
  resource_group_name = var.rg_name
  sku                 = "PerGB2018"
  retention_in_days   = 30 # Denetim için logları 30 gün saklıyoruz
}

# 2. Üzerinde Güvenlik Operasyonları Gerçekleştireceğimiz Kritik Key Vault
resource "random_id" "kv_suffix" {
  byte_length = 2
}

data "azurerm_client_config" "current" {}

resource "azurerm_key_vault" "critical_vault" {
  name                        = "kritik-kasa-${random_id.kv_suffix.hex}"
  location                    = var.location
  resource_group_name         = var.rg_name
  tenant_id                   = data.azurerm_client_config.current.tenant_id
  sku_name                    = "standard"
  soft_delete_retention_days  = 7
  purge_protection_enabled    = false
access_policy {
    tenant_id = data.azurerm_client_config.current.tenant_id
    object_id = "0335ae15-9909-41b2-a818-a570b8ad8792" # Hata mesajından aldığımız senin OID bilgin

    secret_permissions = [
      "Get", "List", "Set", "Delete"
    ]
  }
}