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
  name                = "muhasebe-app-plan-lab" # İsim güncellendi
  location            = var.location # Loglardaki güncel bölgeye sadık kalıyoruz
  resource_group_name = var.rg_name # Yeni RG adın
  os_type             = "Linux"
  sku_name            = "B1"
}

resource "azurerm_linux_web_app" "web_app" {
  name                = "muhasebe-finans-webapp-lab" # Küresel çakışmayı önlemek için değiştirildi
  location            = var.location
  resource_group_name = var.rg_name
  service_plan_id     = azurerm_service_plan.app_plan.id

  site_config {
    always_on = false
    application_stack {
      dotnet_version = "8.0"
    }
  }

  identity {
    type = "SystemAssigned"
  }

  app_settings = {
    "ENVIRONMENT"       = "Production"
    "KEYVAULT_ENDPOINT" = azurerm_key_vault.vault.vault_uri
  }
}