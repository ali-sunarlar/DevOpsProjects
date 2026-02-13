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
  skip_provider_registration = true
}

# 1. Mevcut Playground RG Bilgisi
data "azurerm_resource_group" "lab_rg" {
  name = "1-2c494191-playground-sandbox" # Kendi sandbox RG ismini buraya yaz
}

# 2. Altyapı Hazırlığı (VM ve Ağ)
resource "azurerm_virtual_network" "vnet" {
  name                = "az104-10-vnet1"
  address_space       = ["10.10.0.0/16"]
  location            = data.azurerm_resource_group.lab_rg.location
  resource_group_name = data.azurerm_resource_group.lab_rg.name
}

resource "azurerm_subnet" "subnet" {
  name                 = "subnet0"
  resource_group_name  = data.azurerm_resource_group.lab_rg.name
  virtual_network_name = azurerm_virtual_network.vnet.name
  address_prefixes     = ["10.10.0.0/24"]
}

resource "azurerm_network_interface" "nic" {
  name                = "az104-10-nic0"
  location            = data.azurerm_resource_group.lab_rg.location
  resource_group_name = data.azurerm_resource_group.lab_rg.name

  ip_configuration {
    name                          = "internal"
    subnet_id                     = azurerm_subnet.subnet.id
    private_ip_address_allocation = "Dynamic"
  }
}

resource "azurerm_windows_virtual_machine" "vm" {
  name                = "az104-10-vm0"
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

# 3. Recovery Services Vault (Task 2)
resource "azurerm_recovery_services_vault" "vault" {
  name                = "az104-rsv-region1"
  location            = data.azurerm_resource_group.lab_rg.location
  resource_group_name = data.azurerm_resource_group.lab_rg.name
  sku                 = "Standard"
  soft_delete_enabled = true
}

# 4. Backup Policy (Task 3)
resource "azurerm_backup_policy_vm" "policy" {
  name                = "az104-backup-policy"
  resource_group_name = data.azurerm_resource_group.lab_rg.name
  recovery_vault_name = azurerm_recovery_services_vault.vault.name

  timezone = "UTC"

  backup {
    frequency = "Daily"
    time      = "00:00"
  }

  retention_daily {
    count = 7
  }
}

# 5. Yedeklemeyi Etkinleştir (Task 3)
resource "azurerm_backup_protected_vm" "protected_vm" {
  resource_group_name = data.azurerm_resource_group.lab_rg.name
  recovery_vault_name = azurerm_recovery_services_vault.vault.name
  source_vm_id        = azurerm_windows_virtual_machine.vm.id
  backup_policy_id    = azurerm_backup_policy_vm.policy.id
}

# 6. İzleme İçin Storage Account (Task 4)
resource "azurerm_storage_account" "monitoring_sa" {
  name                     = "stbakmon${lower(substr(data.azurerm_resource_group.lab_rg.name, -6, -1))}"
  resource_group_name      = data.azurerm_resource_group.lab_rg.name
  location                 = data.azurerm_resource_group.lab_rg.location
  account_tier             = "Standard"
  account_replication_type = "LRS"
}