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
  default = "France Central"
}

variable "admin_username" {
  default = "localadmin"
}

variable "admin_password" {
  default = "P@ssw0rd1234!"
}

# 2. Resource Group
resource "azurerm_resource_group" "lab08_rg" {
  name     = "az104-rg8"
  location = var.location
}

# --- TASK 1: Zone-Resilient Virtual Machines ---

resource "azurerm_virtual_network" "vnet_vms" {
  name                = "vnet-vms"
  address_space       = ["10.81.0.0/16"]
  location            = azurerm_resource_group.lab08_rg.location
  resource_group_name = azurerm_resource_group.lab08_rg.name
}

resource "azurerm_subnet" "subnet_vms" {
  name                 = "subnet0"
  resource_group_name  = azurerm_resource_group.lab08_rg.name
  virtual_network_name = azurerm_virtual_network.vnet_vms.name
  address_prefixes     = ["10.81.0.0/24"]
}

# VM NIC'leri (Zone 1 ve Zone 2 için)
resource "azurerm_network_interface" "vm_nics" {
  count               = 2
  name                = "az104-nic${count.index + 1}"
  location            = azurerm_resource_group.lab08_rg.location
  resource_group_name = azurerm_resource_group.lab08_rg.name

  ip_configuration {
    name                          = "internal"
    subnet_id                     = azurerm_subnet.subnet_vms.id
    private_ip_address_allocation = "Dynamic"
  }
}

# Sanal Makineler (VM1 Zone 1, VM2 Zone 2)
resource "azurerm_windows_virtual_machine" "vms" {
  count               = 2
  name                = "az104-vm${count.index + 1}"
  resource_group_name = azurerm_resource_group.lab08_rg.name
  location            = azurerm_resource_group.lab08_rg.location
  size                = "Standard_B2ls_v2" # Kota dostu
  admin_username      = var.admin_username
  admin_password      = var.admin_password
  network_interface_ids = [azurerm_network_interface.vm_nics[count.index].id]
  zone                = count.index + 1 # 1 ve 2. bölgeler

  os_disk {
    caching              = "ReadWrite"
    storage_account_type = "Premium_LRS"
  }

  source_image_reference {
    publisher = "MicrosoftWindowsServer"
    offer     = "WindowsServer"
    sku       = "2022-Datacenter"
    version   = "latest"
  }
}

# --- TASK 3: Virtual Machine Scale Set (VMSS) ---

resource "azurerm_virtual_network" "vmss_vnet" {
  name                = "vmss-vnet"
  address_space       = ["10.82.0.0/20"]
  location            = azurerm_resource_group.lab08_rg.location
  resource_group_name = azurerm_resource_group.lab08_rg.name
}

resource "azurerm_subnet" "vmss_subnet" {
  name                 = "subnet0"
  resource_group_name  = azurerm_resource_group.lab08_rg.name
  virtual_network_name = azurerm_virtual_network.vmss_vnet.name
  address_prefixes     = ["10.82.0.0/24"]
}

resource "azurerm_windows_virtual_machine_scale_set" "vmss1" {
  name                = "vmss1"
  resource_group_name = azurerm_resource_group.lab08_rg.name
  location            = azurerm_resource_group.lab08_rg.location
  sku                 = "Standard_B2ls_v2"
  instances           = 2
  admin_password      = var.admin_password
  admin_username      = var.admin_username
  zones               = ["1", "2", "3"]

  source_image_reference {
    publisher = "MicrosoftWindowsServer"
    offer     = "WindowsServer"
    sku       = "2022-Datacenter"
    version   = "latest"
  }

  os_disk {
    storage_account_type = "Premium_LRS"
    caching              = "ReadWrite"
  }

  network_interface {
    name    = "vmss1-nic"
    primary = true

    ip_configuration {
      name      = "internal"
      primary   = true
      subnet_id = azurerm_subnet.vmss_subnet.id
    }
  }
}

# --- TASK 4: Autoscaling Rules (Ölçeklendirme Kuralları) ---

resource "azurerm_monitor_autoscale_setting" "vmss_scale" {
  name                = "vmss-autoscale"
  resource_group_name = azurerm_resource_group.lab08_rg.name
  location            = azurerm_resource_group.lab08_rg.location
  target_resource_id  = azurerm_windows_virtual_machine_scale_set.vmss1.id

  profile {
    name = "defaultProfile"

    capacity {
      default = 2
      minimum = 2
      maximum = 10
    }

    # Scale Out: CPU > 70% ise %50 artır
    rule {
      metric_trigger {
        metric_name        = "Percentage CPU"
        metric_resource_id = azurerm_windows_virtual_machine_scale_set.vmss1.id
        time_grain         = "PT1M"
        statistic          = "Average"
        time_window        = "PT10M"
        time_aggregation   = "Average"
        operator           = "GreaterThan"
        threshold          = 70
      }

      scale_action {
        direction = "Increase"
        type      = "PercentChangeCount"
        value     = "50"
        cooldown  = "PT5M"
      }
    }

    # Scale In: CPU < 30% ise %50 azalt
    rule {
      metric_trigger {
        metric_name        = "Percentage CPU"
        metric_resource_id = azurerm_windows_virtual_machine_scale_set.vmss1.id
        time_grain         = "PT1M"
        statistic          = "Average"
        time_window        = "PT10M"
        time_aggregation   = "Average"
        operator           = "LessThan"
        threshold          = 30
      }

      scale_action {
        direction = "Decrease"
        type      = "PercentChangeCount"
        value     = "50"
        cooldown  = "PT5M"
      }
    }
  }
}