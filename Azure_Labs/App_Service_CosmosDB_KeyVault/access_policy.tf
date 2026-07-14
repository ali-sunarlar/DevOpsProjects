# Kısır döngüyü kıran kurumsal bağımsız erişim politikası nesnesi
resource "azurerm_key_vault_access_policy" "webapp_policy" {
  key_vault_id = azurerm_key_vault.vault.id
  tenant_id    = data.azurerm_client_config.current.tenant_id
  object_id    = azurerm_linux_web_app.web_app.identity[0].principal_id

  secret_permissions = [
    "Get", "List" # Sadece okuma yetkisi
  ]
}