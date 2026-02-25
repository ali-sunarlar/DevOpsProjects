# --- 1. Terraform & Provider Yapılandırması ---
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
}

# --- 2. Mevcut Kaynak Grubunu Kullan ---
data "azurerm_resource_group" "existing_rg" {
  name = "1-fbe7a07d-playground-sandbox" # Kendi RG adınla değiştir
}

# --- 3. VNet1 Oluşturma (Ek Adres Alanı ile birlikte) ---
# Soruda istenen: Mevcut alana 10.33.0.0/16 eklemek
resource "azurerm_virtual_network" "vnet1" {
  name                = "VNet1"
  resource_group_name = data.azurerm_resource_group.existing_rg.name
  location            = data.azurerm_resource_group.existing_rg.location
  
  # Hem orijinal hem de yeni eklenen adres alanı
  address_space       = ["10.1.0.0/16", "10.33.0.0/16"] 
}

# --- 4. VNet2 Oluşturma ---
resource "azurerm_virtual_network" "vnet2" {
  name                = "VNet2"
  resource_group_name = data.azurerm_resource_group.existing_rg.name
  location            = data.azurerm_resource_group.existing_rg.location
  address_space       = ["10.2.0.0/16"]
}

# --- 5. Peering: VNet1 -> VNet2 ---
resource "azurerm_virtual_network_peering" "peering1to2" {
  name                         = "VNet1-to-VNet2"
  resource_group_name          = data.azurerm_resource_group.existing_rg.name
  virtual_network_name         = azurerm_virtual_network.vnet1.name
  remote_virtual_network_id    = azurerm_virtual_network.vnet2.id
  allow_virtual_network_access = true
  allow_forwarded_traffic      = true
}

# --- 6. Peering: VNet2 -> VNet1 ---
resource "azurerm_virtual_network_peering" "peering2to1" {
  name                         = "VNet2-to-VNet1"
  resource_group_name          = data.azurerm_resource_group.existing_rg.name
  virtual_network_name         = azurerm_virtual_network.vnet2.name
  remote_virtual_network_id    = azurerm_virtual_network.vnet1.id
  allow_virtual_network_access = true
  allow_forwarded_traffic      = true
}