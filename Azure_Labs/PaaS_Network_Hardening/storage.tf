resource "random_id" "storage_suffix" {
  byte_length = 3
}

resource "azurerm_storage_account" "secure_storage" {
  name                     = "sirketfinansdepo${random_id.storage_suffix.hex}" # Benzersiz ve küçük harf
  resource_group_name      = var.rg_name
  location                 = var.location
  account_tier             = "Standard"
  account_replication_type = "LRS"

  # SİBER KALKAN: Ağ Kuralları (Firewall) Yönetimi
  network_rules {
    # Karar verdiğimiz gibi: Önce tüm interneti blokla!
    default_action             = "Deny"
    
    # Sadece bizim Service Endpoint aktif edilmiş alt ağımıza geçiş izni ver
    virtual_network_subnet_ids = [azurerm_subnet.secure_subnet.id]
    
    # Azure portalından durumunu inceleyebilmemiz için Microsoft servislerine istisna tanı
    bypass                     = ["AzureServices"]
  }
}