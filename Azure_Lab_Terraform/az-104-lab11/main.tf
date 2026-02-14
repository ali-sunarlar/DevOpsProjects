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
  # Sandbox yetki hatalarını (403 Forbidden) önlemek için kritik ayar:
  skip_provider_registration = true
}

# 1. Mevcut Playground Resource Group Bilgisi
data "azurerm_resource_group" "lab_rg" {
  name = "1-4539076f-playground-sandbox"
}

# 2. İzleme Testi İçin Sanal Makine Altyapısı (Task 1)
resource "azurerm_virtual_network" "vnet" {
  name                = "az104-11-vnet1"
  address_space       = ["10.11.0.0/16"]
  location            = data.azurerm_resource_group.lab_rg.location
  resource_group_name = data.azurerm_resource_group.lab_rg.name
}

resource "azurerm_subnet" "subnet" {
  name                 = "subnet0"
  resource_group_name  = data.azurerm_resource_group.lab_rg.name
  virtual_network_name = azurerm_virtual_network.vnet.name
  address_prefixes     = ["10.11.0.0/24"]
}

resource "azurerm_network_interface" "nic" {
  name                = "az104-11-nic0"
  location            = data.azurerm_resource_group.lab_rg.location
  resource_group_name = data.azurerm_resource_group.lab_rg.name

  ip_configuration {
    name                          = "internal"
    subnet_id                     = azurerm_subnet.subnet.id
    private_ip_address_allocation = "Dynamic"
  }
}

resource "azurerm_windows_virtual_machine" "vm" {
  name                = "az104-11-vm0"
  resource_group_name = data.azurerm_resource_group.lab_rg.name
  location            = data.azurerm_resource_group.lab_rg.location
  size                = "Standard_B2s"
  admin_username      = "localadmin"
  admin_password      = "P@ssw0rd1234!"
  network_interface_ids = [azurerm_network_interface.nic.id]

  os_disk {
    caching              = "ReadWrite"
    storage_account_type = "Standard_LRS"
  }

  source_image_reference {
    publisher = "MicrosoftWindowsServer"
    offer     = "WindowsServer"
    sku       = "2022-Datacenter-smalldisk"
    version   = "latest"
  }
}

# 3. Action Group - Bildirim Grubu (Task 3)
resource "azurerm_monitor_action_group" "ops_team" {
  name                = "Alert the operations team"
  resource_group_name = data.azurerm_resource_group.lab_rg.name
  short_name          = "AlertOpsTeam"

  email_receiver {
    name                    = "VM was deleted notification"
    email_address           = "it-admin@example.com" # Burayı kendi mailinle güncelleyebilirsin
    use_common_alert_schema = true
  }
}

# 4. Activity Log Alert - VM Silme Uyarısı (Task 2)

# 5. Log Analytics Workspace (Task 6 için)
resource "azurerm_log_analytics_workspace" "law" {
  name                = "az104-11-law"
  location            = data.azurerm_resource_group.lab_rg.location
  resource_group_name = data.azurerm_resource_group.lab_rg.name
  sku                 = "PerGB2018"
  retention_in_days   = 30
}