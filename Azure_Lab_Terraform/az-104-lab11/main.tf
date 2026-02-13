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
  # Sandbox ortamındaki yetki kısıtlamalarını aşmak için
  skip_provider_registration = true
}

# 1. Mevcut Playground RG Bilgisi
data "azurerm_resource_group" "lab_rg" {
  name = "1-2c494191-playground-sandbox" 
}

# 2. İzleme Testi İçin Sanal Ağ
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

# 3. Sanal Makine (Yedekleme ve İzleme Testi İçin)
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

# 4. Action Group (Bildirim Grubu)
resource "azurerm_monitor_action_group" "ops_team" {
  name                = "AlertOperationsTeam"
  resource_group_name = data.azurerm_resource_group.lab_rg.name
  short_name          = "AlertOps"

  email_receiver {
    name                    = "AdminNotification"
    email_address           = "test@example.com" # Burayı güncelleyebilirsin
    use_common_alert_schema = true
  }
}

# 5. Activity Log Alert (Task 2 - Görseldeki Hatalı Bölümün Düzeltilmiş Hali)
resource "azurerm_monitor_activity_log_alert" "vm_delete_alert" {
  name                = "VM was deleted"
  resource_group_name = data.azurerm_resource_group.lab_rg.name
  # Scopes'un data blok üzerinden doğru çağrılması
  scopes              = [data.azurerm_resource_group.lab_rg.id]
  description         = "A VM in your resource group was deleted"

  criteria {
    # Azure standartlarına uygun işlem ismi
    operation_name = "Microsoft.Compute/virtualMachines/delete"
    category       = "Administrative"
  }

  action {
    # Oluşturulan Action Group ID'sinin bağlanması
    action_group_id = azurerm_monitor_action_group.ops_team.id
  }
}

# 6. Log Analytics Workspace (Sorgular İçin)
resource "azurerm_log_analytics_workspace" "law" {
  name                = "az104-11-law"
  location            = data.azurerm_resource_group.lab_rg.location
  resource_group_name = data.azurerm_resource_group.lab_rg.name
  sku                 = "PerGB2018"
  retention_in_days   = 30
}