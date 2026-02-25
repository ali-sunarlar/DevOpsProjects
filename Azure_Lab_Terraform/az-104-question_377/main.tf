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

  # Kullandığın eski versiyon ile uyumlu olan parametre budur:
  skip_provider_registration = true
}

# --- 2. Mevcut Kaynak Grubunu Referans Al ---
data "azurerm_resource_group" "existing_rg" {
  name = "Mevcut_RG_Adiniz" # Laboratuvar ekranındaki RG adını buraya yaz
}

# --- 3. Network Yapısı ---
resource "azurerm_virtual_network" "vnet1" {
  name                = "VNET1"
  address_space       = ["10.1.0.0/16"]
  location            = data.azurerm_resource_group.existing_rg.location
  resource_group_name = data.azurerm_resource_group.existing_rg.name
}

resource "azurerm_subnet" "subnet11" {
  name                 = "Subnet11"
  resource_group_name  = data.azurerm_resource_group.existing_rg.name
  virtual_network_name = azurerm_virtual_network.vnet1.name
  address_prefixes     = ["10.1.1.0/24"]
}

# --- 4. Availability Set ---
resource "azurerm_availability_set" "as1" {
  name                = "AS1"
  location            = data.azurerm_resource_group.existing_rg.location
  resource_group_name = data.azurerm_resource_group.existing_rg.name
}

# --- 5. Internal Load Balancer (Basic SKU) ---
resource "azurerm_lb" "lb1" {
  name                = "LB1"
  location            = data.azurerm_resource_group.existing_rg.location
  resource_group_name = data.azurerm_resource_group.existing_rg.name
  sku                 = "Basic"

  frontend_ip_configuration {
    name                          = "internal-frontend"
    subnet_id                     = azurerm_subnet.subnet11.id
    private_ip_address_allocation = "Dynamic"
  }
}

resource "azurerm_lb_backend_address_pool" "backend_pool" {
  name            = "BackendPool1"
  loadbalancer_id = azurerm_lb.lb1.id
}

# --- 6. Sanal Makineler (VM1 ve VM2) ---
resource "azurerm_network_interface" "nic" {
  count               = 2
  name                = "vm${count.index + 1}-nic"
  location            = data.azurerm_resource_group.existing_rg.location
  resource_group_name = data.azurerm_resource_group.existing_rg.name

  ip_configuration {
    name                          = "internal"
    subnet_id                     = azurerm_subnet.subnet11.id
    private_ip_address_allocation = "Dynamic"
  }
}

resource "azurerm_windows_virtual_machine" "vms" {
  count               = 2
  name                = "VM${count.index + 1}"
  resource_group_name = data.azurerm_resource_group.existing_rg.name
  location            = data.azurerm_resource_group.existing_rg.location
  size                = "Standard_DS1_v2"
  admin_username      = "adminuser"
  admin_password      = "P@ssW0rd12345!"
  
  availability_set_id = azurerm_availability_set.as1.id
  
  network_interface_ids = [
    azurerm_network_interface.nic[count.index].id,
  ]

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

# --- 7. NIC'lerin Backend Pool Bağlantısı ---
resource "azurerm_network_interface_backend_address_pool_association" "assoc" {
  count                   = 2
  network_interface_id    = azurerm_network_interface.nic[count.index].id
  ip_configuration_name   = "internal"
  backend_address_pool_id = azurerm_lb_backend_address_pool.backend_pool.id
}