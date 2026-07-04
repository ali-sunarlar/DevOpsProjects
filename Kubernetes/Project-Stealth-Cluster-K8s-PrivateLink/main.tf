# 1. Azure Sağlayıcı Ayarları
terraform {
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = ">= 4.0.0"
    }
  }
}

provider "azurerm" {
  features {}

  # Sandbox ortamlarındaki kısıtlı RBAC yetki hatalarını (403) engellemek için:
  resource_provider_registrations = "none"
}

# 2. Mevcut Sandbox Kaynak Grubunu Dinamik Yakalama
data "azurerm_resource_group" "lab_rg" {
  # Ekran çıktındaki aktif sandbox adın otomatik yakalanır
  name = "1-b00fa259-playground-sandbox" 
}

# 3. Sanal Ağ (VNet) ve Alt Ağ (Subnet) Mimarisi
resource "azurerm_virtual_network" "vnet" {
  name                = "holding-vnet"
  address_space       = ["10.0.0.0/16"]
  location            = data.azurerm_resource_group.lab_rg.location
  resource_group_name = data.azurerm_resource_group.lab_rg.name
}

resource "azurerm_subnet" "aks_subnet" {
  name                 = "aks-subnet"
  resource_group_name  = data.azurerm_resource_group.lab_rg.name
  virtual_network_name = azurerm_virtual_network.vnet.name
  address_prefixes     = ["10.0.1.0/24"]
}

resource "azurerm_subnet" "db_subnet" {
  name                 = "db-subnet"
  resource_group_name  = data.azurerm_resource_group.lab_rg.name
  virtual_network_name = azurerm_virtual_network.vnet.name
  address_prefixes     = ["10.0.2.0/24"]
}

# 4. Azure Kubernetes Service (AKS) Kümesi
resource "azurerm_kubernetes_cluster" "aks" {
  name                = "muhasebe-aks-cluster"
  location            = data.azurerm_resource_group.lab_rg.location
  resource_group_name = data.azurerm_resource_group.lab_rg.name
  dns_prefix          = "muhasebe-k8s"

  default_node_pool {
    name           = "default"
    node_count     = 1
    vm_size        = "Standard_B2s" # Maliyet ve hız odaklı lab boyutu
    vnet_subnet_id = azurerm_subnet.aks_subnet.id
  }

  # FIX: VNet adres uzayı ile çakışmayı önlemek için Kubernetes iç ağını taşıyoruz
network_profile {
    network_plugin     = "azure"        # Azure CNI moduna geçiyoruz
    service_cidr       = "172.16.0.0/16" # Kubernetes servis trafiği
    dns_service_ip     = "172.16.0.10"   # K8s iç DNS IP'si
  }

  identity {
    type = "SystemAssigned"
  }
}

# 5. PaaS Azure SQL Sunucusu (Görünmez / İzole Mod)
resource "azurerm_mssql_server" "sql_server" {
  name                         = "holding-prod-sqlserver-99"
  resource_group_name          = data.azurerm_resource_group.lab_rg.name
  location                     = data.azurerm_resource_group.lab_rg.location
  version                      = "12.0"
  administrator_login          = "sqladmin"
  administrator_login_password = "P@ssword123456!" # Test ortamı şifresi

  # Veritabanının internetteki dış kapısını tamamen mühürlüyoruz!
  public_network_access_enabled = false
}

# 6. Private Endpoint (Özel Uç Nokta) Tanımı
# Veritabanını db-subnet'in içinden lokal bir IP alacak şekilde ağa gömer.
resource "azurerm_private_endpoint" "sql_pe" {
  name                = "sql-private-endpoint"
  location            = data.azurerm_resource_group.lab_rg.location
  resource_group_name = data.azurerm_resource_group.lab_rg.name
  subnet_id           = azurerm_subnet.db_subnet.id

  private_service_connection {
    name                           = "sql-privatelink-conn"
    private_connection_resource_id = azurerm_mssql_server.sql_server.id
    subresource_names              = ["sqlServer"]
    is_manual_connection           = false
  }
}

# 7. Private DNS Zone ve Ad Çözümleme Sihri (v4+ Uyumlu)
resource "azurerm_private_dns_zone" "sql_dns" {
  name                = "privatelink.database.windows.net"
  resource_group_name = data.azurerm_resource_group.lab_rg.name
}

# DNS bölgesini VNet'e bağlıyoruz
resource "azurerm_private_dns_zone_virtual_network_link" "dns_link" {
  name                  = "vnet-dns-link"
  resource_group_name   = data.azurerm_resource_group.lab_rg.name
  private_dns_zone_name = azurerm_private_dns_zone.sql_dns.name
  virtual_network_id    = azurerm_virtual_network.vnet.id
}

# Private Endpoint'ın aldığı dinamik iç IP'yi DNS'e otomatik işliyoruz
resource "azurerm_private_dns_a_record" "sql_a_record" {
  name                = azurerm_mssql_server.sql_server.name
  zone_name           = azurerm_private_dns_zone.sql_dns.name
  resource_group_name = data.azurerm_resource_group.lab_rg.name
  ttl                 = 300
  records             = [azurerm_private_endpoint.sql_pe.private_service_connection[0].private_ip_address]
}