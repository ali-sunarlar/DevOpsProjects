terraform {
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "~> 3.0"
    }
  }
}

provider "azurerm" {
  features {}
  skip_provider_registration = true
}

# 1. Mevcut Playground Resource Group Bilgisi
data "azurerm_resource_group" "lab_rg" {
  name = "1-2c494191-playground-sandbox" 
}

# 2. App Service Plan - Standart (S1) Tier
# Web App'lerin üzerinde çalışacağı işlem gücü
resource "azurerm_service_plan" "asp" {
  name                = "az104-09a-asp"
  resource_group_name = data.azurerm_resource_group.lab_rg.name
  location            = data.azurerm_resource_group.lab_rg.location
  os_type             = "Windows"
  sku_name            = "S1" # Premium yerine Standart Tier
}

# 3. Web App 1
resource "azurerm_windows_web_app" "webapp1" {
  name                = "az104-09a-webapp1-${random_string.suffix.result}"
  resource_group_name = data.azurerm_resource_group.lab_rg.name
  location            = data.azurerm_resource_group.lab_rg.location
  service_plan_id     = azurerm_service_plan.asp.id

  site_config {
    always_on = true
  }
}

# 4. Web App 2
resource "azurerm_windows_web_app" "webapp2" {
  name                = "az104-09a-webapp2-${random_string.suffix.result}"
  resource_group_name = data.azurerm_resource_group.lab_rg.name
  location            = data.azurerm_resource_group.lab_rg.location
  service_plan_id     = azurerm_service_plan.asp.id

  site_config {
    always_on = true
  }
}

# 5. Traffic Manager Profili
# Gelen trafiği Web App'ler arasında dağıtır
resource "azurerm_traffic_manager_profile" "tm_profile" {
  name                   = "az104-09a-tm-${random_string.suffix.result}"
  resource_group_name    = data.azurerm_resource_group.lab_rg.name
  traffic_routing_method = "Priority" # Öncelik bazlı yönlendirme

  dns_config {
    relative_name = "az104-09a-tm-${random_string.suffix.result}"
    ttl           = 60
  }

  monitor_config {
    protocol                     = "HTTP"
    port                         = 80
    path                         = "/"
    interval_in_seconds          = 30
    timeout_in_seconds           = 9
    tolerated_number_of_failures = 3
  }
}

# 6. Traffic Manager Endpoint - Web App 1
resource "azurerm_traffic_manager_azure_endpoint" "endpoint1" {
  name               = "endpoint1"
  profile_id         = azurerm_traffic_manager_profile.tm_profile.id
  weight             = 1
  priority           = 1
  target_resource_id = azurerm_windows_web_app.webapp1.id
}

# 7. Traffic Manager Endpoint - Web App 2
resource "azurerm_traffic_manager_azure_endpoint" "endpoint2" {
  name               = "endpoint2"
  profile_id         = azurerm_traffic_manager_profile.tm_profile.id
  weight             = 1
  priority           = 2
  target_resource_id = azurerm_windows_web_app.webapp2.id
}

# Benzersiz isimler üretmek için yardımcı araç
resource "random_string" "suffix" {
  length  = 6
  special = false
  upper   = false
}