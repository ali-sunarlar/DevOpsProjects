data "azurerm_client_config" "current" {}

resource "azurerm_key_vault" "vault" {
  name                        = "muhasebe-siber-vault-001"
  location                    = "southcentralus" # Bölge South Central US yapıldı
  resource_group_name         = "1-fbf104d2-playground-sandbox"
  enabled_for_disk_encryption = true
  tenant_id                   = data.azurerm_client_config.current.tenant_id
  soft_delete_retention_days  = 7
  purge_protection_enabled    = false

  sku_name = "standard"

  access_policy {
    tenant_id = data.azurerm_client_config.current.tenant_id
    object_id = data.azurerm_client_config.current.object_id

    secret_permissions = [
      "Get", "List", "Set", "Delete", "Purge"
    ]
  }
}

resource "azurerm_key_vault_secret" "db_password" {
  name         = "CosmosDBConnectionString"
  value        = "SuperSecretPassword123!"
  key_vault_id = azurerm_key_vault.vault.id
}