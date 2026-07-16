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

variable "rg_name" {
  type        = string
  description = "Sandbox tarafından atanan güncel kaynak grubu"
}

# Birincil Bölge (US - South Central)
variable "primary_location" {
  type    = string
  default = "southcentralus"
}

# İkincil Bölge (US - East) -> Politikayı aşmak için 'eastus' yapıldı
variable "secondary_location" {
  type    = string
  default = "eastus"
}