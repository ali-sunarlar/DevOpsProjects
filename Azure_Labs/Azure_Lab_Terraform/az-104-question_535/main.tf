# --- 1. Terraform & Provider Yapılandırması ---
terraform {
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "~> 3.0"
    }
  }
}

provider "azurerm" {
  features {} # Hata almamak için bu blok zorunludur
}

# --- 2. Mevcut Kaynak Grubunu Referans Al ---
data "azurerm_resource_group" "existing_rg" {
  name = "Mevcut_RG_Adiniz" # Burayı kendi RG adınla güncelle
}

# --- 3. Network Altyapısı ---
resource "azurerm_virtual_network" "vnet" {
  name                = "vnet-az104"
  address_space       = ["10.0.0.0/16"]
  location            = data.azurerm_resource_group.existing_rg.location
  resource_group_name = data.azurerm_resource_group.existing_rg.name
}

resource "azurerm_subnet" "subnet" {
  name                 = "internal"
  resource_group_name  = data.azurerm_resource_group.existing_rg.name
  virtual_network_name = azurerm_virtual_network.vnet.name
  address_prefixes     = ["10.0.2.0/24"]
}

resource "azurerm_public_ip" "pip" {
  name                = "vm1-ip"
  resource_group_name = data.azurerm_resource_group.existing_rg.name
  location            = data.azurerm_resource_group.existing_rg.location
  allocation_method   = "Static"
  sku                 = "Standard"
}

resource "azurerm_network_interface" "nic" {
  name                = "vm1-nic"
  location            = data.azurerm_resource_group.existing_rg.location
  resource_group_name = data.azurerm_resource_group.existing_rg.name

  ip_configuration {
    name                          = "internal"
    subnet_id                     = azurerm_subnet.subnet.id
    private_ip_address_allocation = "Dynamic"
    public_ip_address_id          = azurerm_public_ip.pip.id
  }
}

# --- 4. Sanal Makine (VM1) ---
resource "azurerm_windows_virtual_machine" "vm1" {
  name                = "VM1"
  resource_group_name = data.azurerm_resource_group.existing_rg.name
  location            = data.azurerm_resource_group.existing_rg.location
  size                = "Standard_DS1_v2"
  admin_username      = "adminuser"
  admin_password      = "P@ssW0rd12345!" 
  
  network_interface_ids = [azurerm_network_interface.nic.id]

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

  # Azure Monitor Agent (AMA) için zorunlu kimlik
  identity {
    type = "SystemAssigned"
  }
}

# --- 5. Log Analytics Workspace (Destination) ---
resource "azurerm_log_analytics_workspace" "workspace" {
  name                = "Workspace1"
  location            = data.azurerm_resource_group.existing_rg.location
  resource_group_name = data.azurerm_resource_group.existing_rg.name
  sku                 = "PerGB2018"
}

# --- 6. Data Collection Rule (DCR1) ---
resource "azurerm_monitor_data_collection_rule" "dcr1" {
  name                = "DCR1"
  resource_group_name = data.azurerm_resource_group.existing_rg.name
  location            = data.azurerm_resource_group.existing_rg.location

  destinations {
    log_analytics {
      workspace_resource_id = azurerm_log_analytics_workspace.workspace.id
      name                  = "log-analytics-dest"
    }
  }

  data_sources {
    performance_counter {
      streams                       = ["Microsoft-Perf"]
      sampling_frequency_in_seconds = 60
      counter_specifiers            = ["\\Processor(_Total)\\% Processor Time"]
      name                          = "perfCounterSource"
    }
  }

  data_flow {
    streams      = ["Microsoft-Perf"]
    destinations = ["log-analytics-dest"]
  }
}

# --- 7. Azure Monitor Agent Kurulumu ---
resource "azurerm_virtual_machine_extension" "ama" {
  name                       = "AzureMonitorWindowsAgent"
  virtual_machine_id         = azurerm_windows_virtual_machine.vm1.id
  publisher                  = "Microsoft.Azure.Monitor"
  type                       = "AzureMonitorWindowsAgent"
  type_handler_version       = "1.0"
  auto_upgrade_minor_version = true
}

# --- 8. DCR ve VM İlişkilendirmesi (Association) ---
resource "azurerm_monitor_data_collection_rule_association" "assoc" {
  name                    = "vm1-dcr-assoc"
  target_resource_id      = azurerm_windows_virtual_machine.vm1.id
  data_collection_rule_id = azurerm_monitor_data_collection_rule.dcr1.id
  
  # Ajan kurulmadan ilişkilendirme yapmamak için bağımlılık ekliyoruz
  depends_on = [azurerm_virtual_machine_extension.ama]
}