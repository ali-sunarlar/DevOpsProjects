# 1. Sağlayıcı ve Değişkenler
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

variable "location" {
  default = "North Europe"
}

variable "admin_username" {
  default = "localadmin"
}

variable "admin_password" {
  default = "P@ssw0rd1234!" # Lab gereği kompleks bir şifre
}

# 2. Resource Group
resource "azurerm_resource_group" "lab05_rg" {
  name     = "az104-rg5"
  location = var.location
}

# --- AĞ YAPILANDIRMASI ---

# CoreServicesVnet
resource "azurerm_virtual_network" "core_vnet" {
  name                = "CoreServicesVnet"
  address_space       = ["10.0.0.0/16"]
  location            = azurerm_resource_group.lab05_rg.location
  resource_group_name = azurerm_resource_group.lab05_rg.name
}

resource "azurerm_subnet" "core_subnet" {
  name                 = "Core"
  resource_group_name  = azurerm_resource_group.lab05_rg.name
  virtual_network_name = azurerm_virtual_network.core_vnet.name
  address_prefixes     = ["10.0.0.0/24"]
}

# ManufacturingVnet
resource "azurerm_virtual_network" "mfg_vnet" {
  name                = "ManufacturingVnet"
  address_space       = ["172.16.0.0/16"]
  location            = azurerm_resource_group.lab05_rg.location
  resource_group_name = azurerm_resource_group.lab05_rg.name
}

resource "azurerm_subnet" "mfg_subnet" {
  name                 = "Manufacturing"
  resource_group_name  = azurerm_resource_group.lab05_rg.name
  virtual_network_name = azurerm_virtual_network.mfg_vnet.name
  address_prefixes     = ["172.16.0.0/24"]
}

# --- VNET PEERING (Çift Yönlü) ---

resource "azurerm_virtual_network_peering" "core_to_mfg" {
  name                         = "CoreToMfg"
  resource_group_name          = azurerm_resource_group.lab05_rg.name
  virtual_network_name         = azurerm_virtual_network.core_vnet.name
  remote_virtual_network_id    = azurerm_virtual_network.mfg_vnet.id
  allow_virtual_network_access = true
  allow_forwarded_traffic      = true
}

resource "azurerm_virtual_network_peering" "mfg_to_core" {
  name                         = "MfgToCore"
  resource_group_name          = azurerm_resource_group.lab05_rg.name
  virtual_network_name         = azurerm_virtual_network.mfg_vnet.name
  remote_virtual_network_id    = azurerm_virtual_network.core_vnet.id
  allow_virtual_network_access = true
  allow_forwarded_traffic      = true
}

# --- SANAL MAKİNE 1: CoreServicesVM ---

resource "azurerm_network_interface" "core_nic" {
  name                = "core-nic"
  location            = azurerm_resource_group.lab05_rg.location
  resource_group_name = azurerm_resource_group.lab05_rg.name

  ip_configuration {
    name                          = "internal"
    subnet_id                     = azurerm_subnet.core_subnet.id
    private_ip_address_allocation = "Dynamic"
  }
}

resource "azurerm_windows_virtual_machine" "core_vm" {
  name                = "CoreServicesVM"
  resource_group_name = azurerm_resource_group.lab05_rg.name
  location            = azurerm_resource_group.lab05_rg.location
  size                = "Standard_B2ls_v2"
  admin_username      = var.admin_username
  admin_password      = var.admin_password
  network_interface_ids = [azurerm_network_interface.core_nic.id]

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

# --- SANAL MAKİNE 2: ManufacturingVM ---

resource "azurerm_network_interface" "mfg_nic" {
  name                = "mfg-nic"
  location            = azurerm_resource_group.lab05_rg.location
  resource_group_name = azurerm_resource_group.lab05_rg.name

  ip_configuration {
    name                          = "internal"
    subnet_id                     = azurerm_subnet.mfg_subnet.id
    private_ip_address_allocation = "Dynamic"
  }
}

resource "azurerm_windows_virtual_machine" "mfg_vm" {
  name                = "ManufacturingVM"
  resource_group_name = azurerm_resource_group.lab05_rg.name
  location            = azurerm_resource_group.lab05_rg.location
  size                = "Standard_B2ls_v2"
  admin_username      = var.admin_username
  admin_password      = var.admin_password
  network_interface_ids = [azurerm_network_interface.mfg_nic.id]

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

# --- CUSTOM ROUTE TABLE (Task 6) ---

resource "azurerm_route_table" "rt_core" {
  name                = "rt-CoreServices"
  location            = azurerm_resource_group.lab05_rg.location
  resource_group_name = azurerm_resource_group.lab05_rg.name

  route {
    name                   = "PerimetertoCore"
    address_prefix         = "10.0.0.0/16"
    next_hop_type          = "VirtualAppliance"
    next_hop_in_ip_address = "10.0.1.7"
  }
}

resource "azurerm_subnet_route_table_association" "rt_assoc" {
  subnet_id      = azurerm_subnet.core_subnet.id
  route_table_id = azurerm_route_table.rt_core.id
}