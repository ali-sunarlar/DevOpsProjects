resource "azurerm_cosmosdb_account" "cosmos_acc" {
  name                = "muhasebe-nosql-cosmos-001"
  location            = "southcentralus" # Bölge South Central US yapıldı
  resource_group_name = "1-fbf104d2-playground-sandbox"
  offer_type          = "Standard"
  kind                = "GlobalDocumentDB"

  consistency_policy {
    consistency_level = "Session"
  }

  geo_location {
    location          = "southcentralus" # Bölge South Central US yapıldı
    failover_priority = 0
  }
}

resource "azurerm_cosmosdb_sql_database" "cosmos_db" {
  name                = "FaturaDeposu"
  resource_group_name = "1-fbf104d2-playground-sandbox"
  account_name        = azurerm_cosmosdb_account.cosmos_acc.name
}