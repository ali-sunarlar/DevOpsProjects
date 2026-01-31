# 1. Sağlayıcı Yapılandırması
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

# 2. Bölge Değişkeni (North Europe olarak güncellendi)
variable "location" {
  default = "North Europe"
}

# 3. Lab 03 Resource Group (az104-rg3)
resource "azurerm_resource_group" "lab03_rg" {
  name     = "az104-rg3"
  location = var.location
}

# 4. Task 1, 2, 3 & 4: Dört Adet Standart HDD Disk
resource "azurerm_managed_disk" "standard_disks" {
  for_each             = toset(["az104-disk1", "az104-disk2", "az104-disk3", "az104-disk4"])
  name                 = each.key
  location             = azurerm_resource_group.lab03_rg.location
  resource_group_name  = azurerm_resource_group.lab03_rg.name
  storage_account_type = "Standard_LRS"
  create_option        = "Empty"
  disk_size_gb         = 32
}

# 5. Task 5: Bicep Labı için Özel Disk (Standard SSD)
resource "azurerm_managed_disk" "disk5_bicep" {
  name                 = "az104-disk5"
  location             = azurerm_resource_group.lab03_rg.location
  resource_group_name  = azurerm_resource_group.lab03_rg.name
  storage_account_type = "StandardSSD_LRS"
  create_option        = "Empty"
  disk_size_gb         = 32
}

# 6. Cloud Shell ve Lab Dosyaları İçin Storage Account
resource "azurerm_storage_account" "cloudshell_storage" {
  name                     = "staz104lab03${random_string.suffix.result}"
  resource_group_name      = azurerm_resource_group.lab03_rg.name
  location                 = azurerm_resource_group.lab03_rg.location
  account_tier             = "Standard"
  account_replication_type = "LRS"
}

resource "random_string" "suffix" {
  length  = 6
  special = false
  upper   = false
}