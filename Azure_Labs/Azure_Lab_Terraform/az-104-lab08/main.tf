# 1. Sağlayıcı ve Gerekli Modüller
terraform {
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "~> 3.0"
    }
    time = {
      source  = "hashicorp/time"
      version = "~> 0.9"
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

# --- TASK 1: Sanal Makineler (Zone İptal Edildi) ---

resource "azurerm_virtual_network" "vnet_vms" {
  name                = "vnet-vms"
  address_space       = ["10.81.0.0/16"]
  location            = azurerm_resource_group.lab08_rg.location
  resource_group_name = azurerm_resource_group.lab08_rg.name
}

resource "time_sleep" "wait_after_vnet_vms" {
  depends_on      = [azurerm_virtual_network.vnet_vms]
  create_duration = "30s"
}

resource "azurerm_subnet" "subnet_vms" {
  name                 = "subnet0"
  resource_group_name  = azurerm_resource_group.lab08_rg.name
  virtual_network_name = azurerm_virtual_network.vnet_vms.name
  address_prefixes     = ["10.81.0.0/24"]
  depends_on           = [time_sleep.wait_after_vnet_vms]
}

resource "time_sleep" "wait_after_subnet_vms" {
  depends_on      = [azurerm_subnet.subnet_vms]
  create_duration = "20s"
}

resource "azurerm_network_interface" "vm_nics" {
  count               = 1
  name                = "az104-nic${count.index + 1}"
  location            = azurerm_resource_group.lab08_rg.location
  resource_group_name = azurerm_resource_group.lab08_rg.name
  depends_on          = [time_sleep.wait_after_subnet_vms]

  ip_configuration {
    name                          = "internal"
    subnet_id                     = azurerm_subnet.subnet_vms.id
    private_ip_address_allocation = "Dynamic"
  }
}

resource "azurerm_windows_virtual_machine" "vms" {
  count               = 1
  name                = "az104-vm${count.index + 1}"
  resource_group_name = azurerm_resource_group.lab08_rg.name
  location            = azurerm_resource_group.lab08_rg.location
  size                = "Standard_B2ls_v2" 
  admin_username      = var.admin_username
  admin_password      = var.admin_password
  network_interface_ids = [azurerm_network_interface.vm_nics[count.index].id]

  # zone parametresi iptal edildi

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

# --- TASK 3: Virtual Machine Scale Set (Zone İptal Edildi) ---

resource "azurerm_virtual_network" "vmss_vnet" {
  name                = "vmss-vnet"
  address_space       = ["10.82.0.0/20"]
  location            = azurerm_resource_group.lab08_rg.location
  resource_group_name = azurerm_resource_group.lab08_rg.name
}

resource "time_sleep" "wait_after_vmss_vnet" {
  depends_on      = [azurerm_virtual_network.vmss_vnet]
  create_duration = "30s"
}

resource "azurerm_subnet" "vmss_subnet" {
  name                 = "subnet0"
  resource_group_name  = azurerm_resource_group.lab08_rg.name
  virtual_network_name = azurerm_virtual_network.vmss_vnet.name
  address_prefixes     = ["10.82.0.0/24"]
  depends_on           = [time_sleep.wait_after_vmss_vnet]
}

resource "azurerm_windows_virtual_machine_scale_set" "vmss1" {
  name                = "vmss1"
  resource_group_name = azurerm_resource_group.lab08_rg.name
  location            = azurerm_resource_group.lab08_rg.location
  sku                 = "Standard_B2ls_v2"
  instances           = 1
  admin_password      = var.admin_password
  admin_username      = var.admin_username
  
  # zones parametresi iptal edildi
  
  depends_on = [azurerm_subnet.vmss_subnet]

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

# --- TASK 4: Autoscaling Rules (Aynı kalıyor) ---

resource "azurerm_monitor_autoscale_setting" "vmss_scale" {
  name                = "vmss-autoscale"
  resource_group_name = azurerm_resource_group.lab08_rg.name
  location            = azurerm_resource_group.lab08_rg.location
  target_resource_id  = azurerm_windows_virtual_machine_scale_set.vmss1.id

  profile {
    name = "defaultProfile"

    capacity {
      default = 1
      minimum = 1
      maximum = 3
    }

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