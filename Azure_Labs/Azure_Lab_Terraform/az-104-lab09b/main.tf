# 1. Gerekli Sağlayıcılar
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

# 2. Azure Sağlayıcı Yapılandırması (Yetki hataları için güncellendi)
provider "azurerm" {
  features {}
  
  # Sandbox ortamlarındaki "403 Forbidden" kayıt hatasını engellemek için:
  skip_provider_registration = true
}

# 3. Mevcut Playground Resource Group Bilgisi
# Not: Bu blok yeni bir RG oluşturmaz, Azure'daki mevcut grubu okur.
data "azurerm_resource_group" "lab_rg" {
  name = "1-2c494191-playground-sandbox"
}

# 4. DNS Etiketi İçin Benzersiz İsim Üretici
resource "random_string" "dns_label" {
  length  = 6
  special = false
  upper   = false
}

# 5. Azure Container Instance (ACI) Dağıtımı
resource "azurerm_container_group" "aci" {
  name                = "az104-c1"
  location            = data.azurerm_resource_group.lab_rg.location
  resource_group_name = data.azurerm_resource_group.lab_rg.name
  ip_address_type     = "Public"
  dns_name_label      = "az104-c1-${random_string.dns_label.result}"
  os_type             = "Linux"

  container {
    name   = "hello-world"
    image  = "mcr.microsoft.com/azuredocs/aci-helloworld:latest"
    cpu    = "0.5" # Sandbox kotaları için düşük kaynak kullanımı
    memory = "1.5"

    ports {
      port     = 80
      protocol = "TCP"
    }
  }

  tags = {
    Environment = "Training"
    Lab         = "AZ-104-09b"
  }
}

# 6. Çıktı (Output): Konteynere Erişim Adresi
output "container_url" {
  description = "Tarayıcıdan erişebileceğiniz adres:"
  value       = "http://${azurerm_container_group.aci.fqdn}"
}