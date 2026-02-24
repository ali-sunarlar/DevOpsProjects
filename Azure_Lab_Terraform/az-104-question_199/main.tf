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
  name = "Mevcut_RG_Adiniz" # Kendi RG adınla değiştir
}

# --- 3. Storage Account 1: General Purpose v1 (GPv1) ---
# Destekledikleri: Blob, File, Table, Queue
resource "azurerm_storage_account" "storage1" {
  name                     = "storageaccount1gpv1"
  resource_group_name      = data.azurerm_resource_group.existing_rg.name
  location                 = data.azurerm_resource_group.existing_rg.location
  account_tier             = "Standard"
  account_replication_type = "LRS"
  account_kind             = "Storage" # "Storage" değeri GPv1 demektir
}

# --- 4. Storage Account 2: General Purpose v2 (GPv2) ---
# Destekledikleri: Blob, File, Table, Queue (En güncel özellikler)
resource "azurerm_storage_account" "storage2" {
  name                     = "storageaccount2gpv2"
  resource_group_name      = data.azurerm_resource_group.existing_rg.name
  location                 = data.azurerm_resource_group.existing_rg.location
  account_tier             = "Standard"
  account_replication_type = "LRS"
  account_kind             = "StorageV2" # "StorageV2" değeri GPv2 demektir
}

# --- 5. Storage Account 3: Blob Storage (Legacy) ---
# Destekledikleri: Sadece Blob (Table veya Queue DESTEKLEMEZ)
resource "azurerm_storage_account" "storage3" {
  name                     = "storageaccount3blob"
  resource_group_name      = data.azurerm_resource_group.existing_rg.name
  location                 = data.azurerm_resource_group.existing_rg.location
  account_tier             = "Standard"
  account_replication_type = "LRS"
  account_kind             = "BlobStorage" # Sadece Blob destekleyen eski tip
}