resource "azurerm_virtual_network" "vnet" {
  name                = "sirket-siber-vnet"
  address_space       = ["10.0.0.0/16"]
  location            = var.location # Değişken oldu
  resource_group_name = var.rg_name  # Değişken oldu
}

resource "azurerm_subnet" "endpoint_subnet" {
  name                 = "private-endpoints-subnet"
  resource_group_name  = var.rg_name  # Değişken oldu
  virtual_network_name = azurerm_virtual_network.vnet.name
  address_prefixes     = ["10.0.1.0/24"]
}
# ... diğer kaynaklardaki resource_group_name ve location kisimlarini da var.rg_name ve var.location yap Ali.