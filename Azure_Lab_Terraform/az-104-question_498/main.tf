# --- 1. Terraform & Provider Yapılandırması ---
terraform {
  required_providers {
    azurerm = {
      source = "hashicorp/azurerm"
    }
  }
}

provider "azurerm" {
  features {}
  # Laboratuvar yetki kısıtlamaları için en uyumlu parametre
  skip_provider_registration = true
}

# --- 2. Mevcut Kaynak Grubu ---
data "azurerm_resource_group" "existing_rg" {
  name = "1-dde1b9f4-playground-sandbox" # Burayı Azure laboratuvarındaki adla güncelleyin
}

# --- 3. Sanal Ağlar (VNet1 ve VNet2) ---
resource "azurerm_virtual_network" "vnet1" {
  name                = "VNet1"
  address_space       = ["10.1.0.0/16"]
  location            = data.azurerm_resource_group.existing_rg.location
  resource_group_name = data.azurerm_resource_group.existing_rg.name
}

resource "azurerm_virtual_network" "vnet2" {
  name                = "VNet2"
  address_space       = ["10.2.0.0/16"]
  location            = data.azurerm_resource_group.existing_rg.location
  resource_group_name = data.azurerm_resource_group.existing_rg.name
}

# --- 4. Subnetler ---
resource "azurerm_subnet" "vnet1_subnet" {
  name                 = "VMSubnet"
  resource_group_name  = data.azurerm_resource_group.existing_rg.name
  virtual_network_name = azurerm_virtual_network.vnet1.name
  address_prefixes     = ["10.1.1.0/24"]
}

# Soru Gereği: Bastion Subneti /26 olmalı
resource "azurerm_subnet" "bastion_subnet" {
  name                 = "AzureBastionSubnet"
  resource_group_name  = data.azurerm_resource_group.existing_rg.name
  virtual_network_name = azurerm_virtual_network.vnet1.name
  address_prefixes     = ["10.1.2.0/26"]
}

resource "azurerm_subnet" "vnet2_subnet" {
  name                 = "VMSubnet"
  resource_group_name  = data.azurerm_resource_group.existing_rg.name
  virtual_network_name = azurerm_virtual_network.vnet2.name
  address_prefixes     = ["10.2.1.0/24"]
}

# --- 5. VNet Peering ---
resource "azurerm_virtual_network_peering" "vnet1_to_vnet2" {
  name                      = "VNet1-to-VNet2"
  resource_group_name       = data.azurerm_resource_group.existing_rg.name
  virtual_network_name      = azurerm_virtual_network.vnet1.name
  remote_virtual_network_id = azurerm_virtual_network.vnet2.id
}

resource "azurerm_virtual_network_peering" "vnet2_to_vnet1" {
  name                      = "VNet2-to-VNet1"
  resource_group_name       = data.azurerm_resource_group.existing_rg.name
  virtual_network_name      = azurerm_virtual_network.vnet2.name
  remote_virtual_network_id = azurerm_virtual_network.vnet1.id
}

# --- 6. Azure Bastion (Standard SKU) ---
resource "azurerm_public_ip" "bastion_pip" {
  name                = "bastion-ip"
  location            = data.azurerm_resource_group.existing_rg.location
  resource_group_name = data.azurerm_resource_group.existing_rg.name
  allocation_method   = "Static"
  sku                 = "Standard"
}

resource "azurerm_bastion_host" "bastion" {
  name                = "BastionHost"
  location            = data.azurerm_resource_group.existing_rg.location
  resource_group_name = data.azurerm_resource_group.existing_rg.name
  sku                 = "Standard"
  scale_units         = 2

  ip_configuration {
    name                 = "configuration"
    subnet_id            = azurerm_subnet.bastion_subnet.id
    public_ip_address_id = azurerm_public_ip.bastion_pip.id
  }
}

# --- 7. Sanal Makineler ---

# NIC'ler
resource "azurerm_network_interface" "nic1" {
  name                = "vm1-nic"
  location            = data.azurerm_resource_group.existing_rg.location
  resource_group_name = data.azurerm_resource_group.existing_rg.name
  ip_configuration {
    name                          = "internal"
    subnet_id                     = azurerm_subnet.vnet1_subnet.id
    private_ip_address_allocation = "Dynamic"
  }
}

resource "azurerm_network_interface" "nic2" {
  name                = "vm2-nic"
  location            = data.azurerm_resource_group.existing_rg.location
  resource_group_name = data.azurerm_resource_group.existing_rg.name
  ip_configuration {
    name                          = "internal"
    subnet_id                     = azurerm_subnet.vnet2_subnet.id
    private_ip_address_allocation = "Dynamic"
  }
}

# VM 1 (Hata giderilmiş os_disk bloğu)
resource "azurerm_windows_virtual_machine" "vm1" {
  name                = "VM1"
  resource_group_name = data.azurerm_resource_group.existing_rg.name
  location            = data.azurerm_resource_group.existing_rg.location
  size                = "Standard_DS1_v2"
  admin_username      = "adminuser"
  admin_password      = "P@ssW0rd12345!"
  network_interface_ids = [azurerm_network_interface.nic1.id]

  os_disk {
    caching              = "ReadWrite"
    storage_account_type = "Standard_LRS"
  }

  source_image_reference {
    publisher = "MicrosoftWindowsServer"
    offer     = "WindowsServer"
    sku       = "2022-Datacenter"
    version   = "latest"
  }
}

# VM 2
resource "azurerm_windows_virtual_machine" "vm2" {
  name                = "VM2"
  resource_group_name = data.azurerm_resource_group.existing_rg.name
  location            = data.azurerm_resource_group.existing_rg.location
  size                = "Standard_DS1_v2"
  admin_username      = "adminuser"
  admin_password      = "P@ssW0rd12345!"
  network_interface_ids = [azurerm_network_interface.nic2.id]

  os_disk {
    caching              = "ReadWrite"
    storage_account_type = "Standard_LRS"
  }

  source_image_reference {
    publisher = "MicrosoftWindowsServer"
    offer     = "WindowsServer"
    sku       = "2022-Datacenter"
    version   = "latest"
  }
}