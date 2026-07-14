########################################
# 1. Sağlayıcı Yapılandırması
########################################
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

variable "location" {
  default = "West Europe"
}

########################################
# 2. Resource Group
########################################
resource "azurerm_resource_group" "lab07_rg" {
  name     = "az104-rg7"
  location = var.location
}

########################################
# 3. Storage Account (Globally Unique isim gerektirir)
########################################
resource "random_string" "unique_id" {
  length  = 6
  special = false
  upper   = false
}

resource "azurerm_storage_account" "storage" {
  name                     = "alisunarlarsa${random_string.unique_id.result}"
  resource_group_name      = azurerm_resource_group.lab07_rg.name
  location                 = azurerm_resource_group.lab07_rg.location
  account_tier             = "Standard"
  account_replication_type = "RAGRS"
}

########################################
# 4. Lifecycle Management Rule (Task 1)
########################################
resource "azurerm_storage_management_policy" "lifecycle" {
  storage_account_id = azurerm_storage_account.storage.id

  rule {
    name    = "Movetocool"
    enabled = true
    filters {
      blob_types = ["blockBlob"]
    }
    actions {
      base_blob {
        tier_to_cool_after_days_since_modification_greater_than = 30
      }
    }
  }
}

########################################
# 5. Blob Container (Task 2)
########################################
resource "azurerm_storage_container" "data_container" {
  name                  = "data"
  storage_account_name  = azurerm_storage_account.storage.name
  container_access_type = "private"
}

########################################
# 6. File Share (Task 3)
########################################
resource "azurerm_storage_share" "share1" {
  name                 = "share1"
  storage_account_name = azurerm_storage_account.storage.name
  quota                = 5120 # 5 TB Varsayılan
}

########################################
# 7. VNet ve Subnet
########################################
resource "azurerm_virtual_network" "vnet1" {
  name                = "vnet1"
  address_space       = ["10.70.0.0/16"]
  location            = azurerm_resource_group.lab07_rg.location
  resource_group_name = azurerm_resource_group.lab07_rg.name
}

resource "azurerm_subnet" "default_subnet" {
  name                 = "default"
  resource_group_name  = azurerm_resource_group.lab07_rg.name
  virtual_network_name = azurerm_virtual_network.vnet1.name
  address_prefixes     = ["10.70.0.0/24"]

  # Storage erişimi için Endpoint ekle
  service_endpoints    = ["Microsoft.Storage"]
}

########################################
# 8. Storage Network Rule (Task 1)
########################################
resource "azurerm_storage_account_network_rules" "allow_vnet" {
  storage_account_id       = azurerm_storage_account.storage.id
  default_action           = "Deny"
  virtual_network_subnet_ids = [azurerm_subnet.default_subnet.id]
  bypass                   = ["AzureServices"]
}
