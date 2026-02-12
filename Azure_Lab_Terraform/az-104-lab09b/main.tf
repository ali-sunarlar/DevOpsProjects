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

# 1. Mevcut Playground RG Bilgisi (Öncekiyle aynı RG)
data "azurerm_resource_group" "lab09_rg" {
  name = "1-f1ea02d7-playground-sandbox"
}

# 2. DNS İsmi İçin Benzersiz İsim Üretici
resource "random_string" "dns_label" {
  length  = 8
  special = false
  upper   = false
}

# 3. Azure Container Instance (ACI) Dağıtımı
resource "azurerm_container_group" "aci" {
  name                = "az104lab09b-c1"
  location            = data.azurerm_resource_group.lab09_rg.location
  resource_group_name = data.azurerm_resource_group.lab09_rg.name
  ip_address_type     = "Public"
  dns_name_label      = "az104lab09b-c1-${random_string.dns_label.result}"
  os_type             = "Linux"

  container {
    name   = "hello-world"
    image  = "mcr.microsoft.com/azuredocs/aci-helloworld:latest"
    cpu    = "0.5" # Kota dostu olması için 0.5 CPU
    memory = "1.5"

    ports {
      port     = 80
      protocol = "TCP"
    }
  }

  tags = {
    environment = "training"
    lab         = "AZ-104-09b"
  }
}

# 4. Çıktı Olarak FQDN (Erişim Adresi) Bilgisini Ver
output "container_url" {
  value = "http://${azurerm_container_group.aci.fqdn}"
}