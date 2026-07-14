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

variable "location" {
  default = "North Europe"
}

# 2. Resource Group
resource "azurerm_resource_group" "lab04_rg" {
  name     = "az104-rg4"
  location = var.location
}

# 3. CoreServicesVnet ve Subnetleri
resource "azurerm_virtual_network" "core_vnet" {
  name                = "CoreServicesVnet"
  address_space       = ["10.20.0.0/16"]
  location            = azurerm_resource_group.lab04_rg.location
  resource_group_name  = azurerm_resource_group.lab04_rg.name
}

resource "azurerm_subnet" "shared_services" {
  name                 = "SharedServicesSubnet"
  resource_group_name  = azurerm_resource_group.lab04_rg.name
  virtual_network_name = azurerm_virtual_network.core_vnet.name
  address_prefixes     = ["10.20.10.0/24"]
}

resource "azurerm_subnet" "database_subnet" {
  name                 = "DatabaseSubnet"
  resource_group_name  = azurerm_resource_group.lab04_rg.name
  virtual_network_name = azurerm_virtual_network.core_vnet.name
  address_prefixes     = ["10.20.20.0/24"]
}

# 4. ManufacturingVnet ve Subnetleri
resource "azurerm_virtual_network" "mfg_vnet" {
  name                = "ManufacturingVnet"
  address_space       = ["10.30.0.0/16"]
  location            = azurerm_resource_group.lab04_rg.location
  resource_group_name  = azurerm_resource_group.lab04_rg.name
}

resource "azurerm_subnet" "sensor_subnet1" {
  name                 = "SensorSubnet1"
  resource_group_name  = azurerm_resource_group.lab04_rg.name
  virtual_network_name = azurerm_virtual_network.mfg_vnet.name
  address_prefixes     = ["10.30.20.0/24"]
}

resource "azurerm_subnet" "sensor_subnet2" {
  name                 = "SensorSubnet2"
  resource_group_name  = azurerm_resource_group.lab04_rg.name
  virtual_network_name = azurerm_virtual_network.mfg_vnet.name
  address_prefixes     = ["10.30.21.0/24"]
}

# 5. Application Security Group (ASG)
resource "azurerm_application_security_group" "asg_web" {
  name                = "asg-web"
  location            = azurerm_resource_group.lab04_rg.location
  resource_group_name = azurerm_resource_group.lab04_rg.name
}

# 6. Network Security Group (NSG) ve Kurallar
resource "azurerm_network_security_group" "nsg_secure" {
  name                = "myNSGSecure"
  location            = azurerm_resource_group.lab04_rg.location
  resource_group_name = azurerm_resource_group.lab04_rg.name

  # Inbound Rule: Allow ASG traffic
  security_rule {
    name                                       = "AllowASG"
    priority                                   = 100
    direction                                  = "Inbound"
    access                                     = "Allow"
    protocol                                   = "Tcp"
    source_port_range                          = "*"
    destination_port_ranges                    = ["80", "443"]
    source_application_security_group_ids      = [azurerm_application_security_group.asg_web.id]
    destination_address_prefix                 = "*"
  }

  # Outbound Rule: Deny Internet Access
  security_rule {
    name                       = "DenyInternetOutbound"
    priority                   = 4096
    direction                  = "Outbound"
    access                     = "Deny"
    protocol                   = "*"
    source_port_range          = "*"
    destination_port_range     = "*"
    source_address_prefix      = "*"
    destination_address_prefix = "Internet"
  }
}

# NSG'yi SharedServicesSubnet ile ilişkilendir
resource "azurerm_subnet_network_security_group_association" "nsg_assoc" {
  subnet_id                 = azurerm_subnet.shared_services.id
  network_security_group_id = azurerm_network_security_group.nsg_secure.id
}

# 7. DNS Zones
resource "azurerm_dns_zone" "public_dns" {
  name                = "alisunarlar.com" # Gerçek dünyada benzersiz olmalı
  resource_group_name = azurerm_resource_group.lab04_rg.name
}

resource "azurerm_private_dns_zone" "private_dns" {
  name                = "private.alisunarlar.com"
  resource_group_name = azurerm_resource_group.lab04_rg.name
}

# Private DNS Link (ManufacturingVnet ile bağla)
resource "azurerm_private_dns_zone_virtual_network_link" "mfg_link" {
  name                  = "manufacturing-link"
  resource_group_name   = azurerm_resource_group.lab04_rg.name
  private_dns_zone_name = azurerm_private_dns_zone.private_dns.name
  virtual_network_id    = azurerm_virtual_network.mfg_vnet.id
}