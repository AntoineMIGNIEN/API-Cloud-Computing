# Génère un nom d'animal aléatoire pour garantir un nom unique
resource "random_pet" "cosmosdb_name" {
  length    = 2  # Nombre de mots dans le nom
  separator = "-"  # Séparateur entre les mots
}

# This file is used to create a resource group in Azure
resource "azurerm_resource_group" "rg" {
    name     = "api-cloud-computing"
    location = var.location
}

# This file is used to create a CosmosDB account in Azure
resource "azurerm_cosmosdb_account" "cosmosdb_account" {
  name                      = "${random_pet.cosmosdb_name.id}-api-cc-cosmosdb"
  location                  = var.cosmosdb_account_location
  resource_group_name       = azurerm_resource_group.rg.name
  offer_type                = "Standard"
  kind                      = "GlobalDocumentDB"
  geo_location {
    location          = var.location
    failover_priority = 0
  }
  consistency_policy {
    consistency_level       = "BoundedStaleness"
    max_interval_in_seconds = 300
    max_staleness_prefix    = 100000
  }
  depends_on = [
    azurerm_resource_group.rg
  ]
}


resource "azurerm_cosmosdb_sql_database" "main" {
  name                = "api-cosmos-sqldb"
  resource_group_name = azurerm_resource_group.rg.name
  account_name        = azurerm_cosmosdb_account.cosmosdb_account.name
}

resource "azurerm_cosmosdb_sql_container" "main" {
  name                = "api-cosmos-sqlcontainer"
  resource_group_name = azurerm_resource_group.rg.name
  account_name        = azurerm_cosmosdb_account.cosmosdb_account.name
  database_name       = azurerm_cosmosdb_sql_database.main.name
  partition_key_paths  = ["/definition/id"]
  partition_key_version = 1

  indexing_policy {
    indexing_mode = "consistent"

    included_path {
      path = "/*"
    }

    included_path {
      path = "/included/?"
    }

    excluded_path {
      path = "/excluded/?"
    }
  }

  unique_key {
    paths = ["/definition/idlong", "/definition/idshort"]
  }

}
