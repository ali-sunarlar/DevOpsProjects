terraform {
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = ">= 3.0"
    }
  }
}

provider "azurerm" {
  resource_provider_registrations = "none"
  features {}
}

resource "azurerm_service_plan" "app_plan" {
  name                = "muhasebe-app-plan"
  location            = "southcentralus" # Bölge South Central US yapıldı
  resource_group_name = "1-fbf104d2-playground-sandbox"
  os_type             = "Linux"
  sku_name            = "B1"
}

resource "azurerm_linux_web_app" "web_app" {
  name                = "muhasebe-finans-webapp-001"
  location            = "southcentralus"
  resource_group_name = "1-fbf104d2-playground-sandbox"
  service_plan_id     = azurerm_service_plan.app_plan.id

  site_config {
    always_on = false
    application_stack {
      dotnet_version = "8.0"
    }
  }

  app_settings = {
    "ENVIRONMENT" = "Production"
  }
}