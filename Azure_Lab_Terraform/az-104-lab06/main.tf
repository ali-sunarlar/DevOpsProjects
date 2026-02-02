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
  default = "Sweden Central"
}

variable "admin_username" {
  default = "localadmin"
}

variable "admin_password" {
  default = "P@ssw0rd1234!" 
}

# 2. Resource Group
resource "azurerm_resource_group" "lab06_rg" {
  name     = "az104-rg6"
  location = var.location
}

# 3. Sanal Ağ ve Bekleme Süresi
resource "azurerm_virtual_network" "vnet1" {
  name                = "az104-06-vnet1"
  address_space       = ["10.60.0.0/16"]
  location            = azurerm_resource_group.lab06_rg.location
  resource_group_name = azurerm_resource_group.lab06_rg.name
}

resource "time_sleep" "wait_after_vnet" {
  depends_on      = [azurerm_virtual_network.vnet1]
  create_duration = "30s"
}

# 4. Subnetler
resource "azurerm_subnet" "subnets" {
  count                = 2
  name                 = "subnet${count.index}"
  resource_group_name  = azurerm_resource_group.lab06_rg.name
  virtual_network_name = azurerm_virtual_network.vnet1.name
  address_prefixes     = ["10.60.${count.index}.0/24"]
  depends_on           = [time_sleep.wait_after_vnet]
}

resource "azurerm_subnet" "subnet_appgw" {
  name                 = "subnet-appgw"
  resource_group_name  = azurerm_resource_group.lab06_rg.name
  virtual_network_name = azurerm_virtual_network.vnet1.name
  address_prefixes     = ["10.60.3.224/27"]
  depends_on           = [time_sleep.wait_after_vnet]
}

# 5. Sanal Makineler (B2ls_v2 - Kota Dostu)
resource "azurerm_network_interface" "vm_nics" {
  count               = 2
  name                = "az104-06-nic${count.index}"
  location            = azurerm_resource_group.lab06_rg.location
  resource_group_name = azurerm_resource_group.lab06_rg.name

  ip_configuration {
    name                          = "internal"
    subnet_id                     = azurerm_subnet.subnets[count.index].id
    private_ip_address_allocation = "Dynamic"
  }
}

resource "azurerm_windows_virtual_machine" "vms" {
  count               = 2
  name                = "az104-06-vm${count.index}"
  resource_group_name = azurerm_resource_group.lab06_rg.name
  location            = azurerm_resource_group.lab06_rg.location
  size                = "Standard_B2ls_v2" 
  admin_username      = var.admin_username
  admin_password      = var.admin_password
  network_interface_ids = [azurerm_network_interface.vm_nics[count.index].id]

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

# 6. Public IPs ve Bekleme Süresi
resource "azurerm_public_ip" "lb_pip" {
  name                = "az104-lbpip"
  location            = azurerm_resource_group.lab06_rg.location
  resource_group_name = azurerm_resource_group.lab06_rg.name
  allocation_method   = "Static"
  sku                 = "Standard"
}

resource "azurerm_public_ip" "appgw_pip" {
  name                = "az104-gwpip"
  location            = azurerm_resource_group.lab06_rg.location
  resource_group_name = azurerm_resource_group.lab06_rg.name
  allocation_method   = "Static"
  sku                 = "Standard"
}

resource "time_sleep" "wait_after_pips" {
  depends_on      = [azurerm_public_ip.lb_pip, azurerm_public_ip.appgw_pip]
  create_duration = "30s"
}

# 7. Load Balancer (L4)
resource "azurerm_lb" "lb" {
  name                = "az104-lb"
  location            = azurerm_resource_group.lab06_rg.location
  resource_group_name = azurerm_resource_group.lab06_rg.name
  sku                 = "Standard"
  depends_on          = [time_sleep.wait_after_pips]

  frontend_ip_configuration {
    name                 = "az104-fe"
    public_ip_address_id = azurerm_public_ip.lb_pip.id
  }
}

resource "azurerm_lb_backend_address_pool" "lb_be" {
  loadbalancer_id = azurerm_lb.lb.id
  name            = "az104-be"
}

resource "azurerm_network_interface_backend_address_pool_association" "lb_assoc" {
  count                   = 2
  network_interface_id    = azurerm_network_interface.vm_nics[count.index].id
  ip_configuration_name   = "internal"
  backend_address_pool_id = azurerm_lb_backend_address_pool.lb_be.id
}

resource "azurerm_lb_probe" "hp" {
  loadbalancer_id = azurerm_lb.lb.id
  name            = "az104-hp"
  port            = 80
}

resource "azurerm_lb_rule" "lb_rule" {
  loadbalancer_id                = azurerm_lb.lb.id
  name                           = "az104-lbrule"
  protocol                       = "Tcp"
  frontend_port                  = 80
  backend_port                   = 80
  frontend_ip_configuration_name = "az104-fe"
  backend_address_pool_ids        = [azurerm_lb_backend_address_pool.lb_be.id]
  probe_id                       = azurerm_lb_probe.hp.id
}

# 8. Application Gateway (L7)
resource "azurerm_application_gateway" "appgw" {
  name                = "az104-appgw"
  resource_group_name = azurerm_resource_group.lab06_rg.name
  location            = azurerm_resource_group.lab06_rg.location
  
  # Kritik bağımlılık zinciri
  depends_on = [time_sleep.wait_after_pips, azurerm_subnet.subnet_appgw, azurerm_lb.lb]

  ssl_policy {
    policy_type = "Predefined"
    policy_name = "AppGwSslPolicy20220101"
  }

  sku {
    name     = "Standard_v2"
    tier     = "Standard_v2"
    capacity = 2
  }

  gateway_ip_configuration {
    name      = "gw-ip-config"
    subnet_id = azurerm_subnet.subnet_appgw.id
  }

  frontend_port {
    name = "fe-port"
    port = 80
  }

  frontend_ip_configuration {
    name                 = "fe-ip"
    public_ip_address_id = azurerm_public_ip.appgw_pip.id
  }

  backend_address_pool {
    name = "az104-appgwbe"
    ip_addresses = [for nic in azurerm_network_interface.vm_nics : nic.private_ip_address]
  }

  backend_http_settings {
    name                  = "az104-http"
    cookie_based_affinity = "Disabled"
    port                  = 80
    protocol              = "Http"
    request_timeout       = 60
  }

  http_listener {
    name                           = "az104-listener"
    frontend_ip_configuration_name = "fe-ip"
    frontend_port_name             = "fe-port"
    protocol                       = "Http"
  }

  request_routing_rule {
    name                       = "az104-gwrule"
    rule_type                  = "Basic"
    http_listener_name         = "az104-listener"
    backend_address_pool_name  = "az104-appgwbe"
    backend_http_settings_name = "az104-http"
    priority                   = 10
  }
}