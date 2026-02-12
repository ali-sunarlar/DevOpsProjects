terraform {
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "~> 3.0"
    }
    random = {
      source  = "hashicorp/random"
      version = "~> 3.0"
    }
  }
}

provider "azurerm" {
  features {}
}

# 1. Mevcut Playground RG Bilgisi
data "azurerm_resource_group" "lab09_rg" {
  name = "1-f1ea02d7-playground-sandbox"
}

# 2. Benzersiz İsim Üretici
resource "random_string" "app_name" {
  length  = 8
  special = false
  upper   = false
}

# 3. App Service Plan
resource "azurerm_service_plan" "plan" {
  name                = "az104-sp9"
  resource_group_name = data.azurerm_resource_group.lab09_rg.name
  location            = data.azurerm_resource_group.lab09_rg.location
  os_type             = "Linux"
  # Eğer Sandbox S1'e izin veriyorsa S1 kalsın, vermiyorsa B1 yapabilirsin.
  sku_name            = "S1" 
}

# 4. Web App (Production)
resource "azurerm_linux_web_app" "webapp" {
  name                = "az104-webapp-${random_string.app_name.result}"
  resource_group_name = data.azurerm_resource_group.lab09_rg.name
  location            = data.azurerm_resource_group.lab09_rg.location
  service_plan_id     = azurerm_service_plan.plan.id

  site_config {
    application_stack {
      php_version = "8.2"
    }
  }
}

# 5. Deployment Slot (Staging)
resource "azurerm_linux_web_app_slot" "staging" {
  name           = "staging"
  app_service_id = azurerm_linux_web_app.webapp.id

  site_config {
    application_stack {
      php_version = "8.2"
    }
  }
}

# 6. Source Control (GitHub Örnek Kod - Staging Slot)
resource "azurerm_app_service_source_control_slot" "git" {
  slot_id                = azurerm_linux_web_app_slot.staging.id
  repo_url               = "https://github.com/Azure-Samples/php-docs-hello-world"
  branch                 = "master"
  use_manual_integration = true
}