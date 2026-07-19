# 1. Şirket Ana Sanal Ağı
resource "azurerm_virtual_network" "company_vnet" {
  name                = "sirket-ana-vnet"
  address_space       = ["10.0.0.0/16"]
  location            = var.location
  resource_group_name = var.rg_name
}

# 2. Microsoft.Storage Yetkisi Verilmiş Zırhlı Alt Ağ
resource "azurerm_subnet" "secure_subnet" {
  name                 = "finans-islem-subnet"
  resource_group_name  = var.rg_name
  virtual_network_name = azurerm_virtual_network.company_vnet.name
  address_prefixes     = ["10.0.1.0/24"]

  # SİHİRLİ DOKUNUŞ: Bu alt ağdan Storage Account'a internete çıkmadan siber tünel açar
  service_endpoints    = ["Microsoft.Storage"]

}