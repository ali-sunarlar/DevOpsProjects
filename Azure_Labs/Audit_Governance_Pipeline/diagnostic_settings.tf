# Key Vault Derinlemesine İzleme Hattı (Diagnostic Setting)
resource "azurerm_monitor_diagnostic_setting" "kv_audit" {
  name                       = "keyvault-derin-denetim"
  target_resource_id         = azurerm_key_vault.critical_vault.id
  log_analytics_workspace_id = azurerm_log_analytics_workspace.audit_center.id

  # 1. Kasa içindeki gizli şifreleri kim okudu/yazdı? (Data Plane Logu)
  enabled_log {
    category = "AuditEvent"
  }

  # 2. Kasaya gelen tüm metrikleri (Saniyede kaç istek düştü vb.) de merkeze topla
  metric {
    category = "AllMetrics"
    enabled  = true
  }
}