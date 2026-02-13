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
  # Sandbox yetki kısıtlamaları için:
  skip_provider_registration = true
}

# 1. Mevcut Playground RG Bilgisi
data "azurerm_resource_group" "lab_rg" {
  name = "1-2c494191-playground-sandbox"
}

# 2. Container App Environment (Yönetilen Kubernetes Ortamı)
resource "azurerm_container_app_environment" "env" {
  name                = "my-environment"
  location            = data.azurerm_resource_group.lab_rg.location
  resource_group_name = data.azurerm_resource_group.lab_rg.name
}

# 3. Azure Container App
resource "azurerm_container_app" "app" {
  name                         = "my-app"
  container_app_environment_id = azurerm_container_app_environment.env.id
  resource_group_name          = data.azurerm_resource_group.lab_rg.name
  revision_mode                = "Single"

  template {
    container {
      name   = "simple-hello-world"
      image  = "mcr.microsoft.com/k8se/quickstart:latest"
      cpu    = 0.25
      memory = "0.5Gi"
    }
  }

  ingress {
    allow_insecure_connections = false
    external_enabled           = true
    target_port                = 80
    traffic_weight {
      percentage      = 100
      latest_revision = true
    }
  }

  tags = {
    Lab = "AZ-104-09c"
  }
}

# 4. Çıktı: Uygulama URL'si
output "application_url" {
  value = "https://${azurerm_container_app.app.latest_revision_fqdn}"
}