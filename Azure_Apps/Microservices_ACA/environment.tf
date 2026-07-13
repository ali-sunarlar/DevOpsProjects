# 1. Merkezi Log Deposu (Log Analytics Workspace)
resource "azurerm_log_analytics_workspace" "logs" {
  name                = "aca-mikroservis-logs"
  location            = var.location
  resource_group_name = var.rg_name
  sku                 = "PerGB2018"
  retention_in_days   = 30
}

# 2. Mikroservis Ortak Yaşam Alanı (Container Apps Environment)
resource "azurerm_container_app_environment" "aca_env" {
  name                       = "sirket-microservices-env"
  location                   = var.location
  resource_group_name        = var.rg_name
  log_analytics_workspace_id = azurerm_log_analytics_workspace.logs.id
}