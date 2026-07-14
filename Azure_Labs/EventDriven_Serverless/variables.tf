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

variable "location" {
  type        = string
  default     = "southcentralus"
}