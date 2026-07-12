resource "azurerm_cosmosdb_account" "cosmos_acc" {
  name                = "muhasebe-nosql-cosmos-001"
  location            = var.location # Bölge South Central US yapıldı
  resource_group_name = var.rg_name
  offer_type          = "Standard"
  kind                = "GlobalDocumentDB"

  consistency_policy {
    consistency_level = "Session"
  }

  geo_location {
    location          = var.location # Bölge South Central US yapıldı
    failover_priority = 0
  }
}

resource "azurerm_cosmosdb_sql_database" "cosmos_db" {
  name                = "FaturaDeposu"
  resource_group_name = var.rg_name
  account_name        = azurerm_cosmosdb_account.cosmos_acc.name
}