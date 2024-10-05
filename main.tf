# Génère un nom d'animal aléatoire pour garantir un nom unique
resource "random_pet" "cosmosdb_name" {
  length    = 2  # Nombre de mots dans le nom
  separator = "-"  # Séparateur entre les mots
}

# This file is used to create a resource group in Azure
resource "azurerm_resource_group" "rg" {
    name     = "${random_pet.cosmosdb_name.id}-api-cloud-computing"
    location = var.location
}

# # This file is used to create a CosmosDB account in Azure
# resource "azurerm_cosmosdb_account" "cosmosdb_account" {
#   name                      = "${random_pet.cosmosdb_name.id}-api-cc-cosmosdb"
#   location                  = var.cosmosdb_account_location
#   resource_group_name       = azurerm_resource_group.rg.name
#   offer_type                = "Standard"
#   kind                      = "GlobalDocumentDB"
#   geo_location {
#     location          = var.location
#     failover_priority = 0
#   }
#   consistency_policy {
#     consistency_level       = "BoundedStaleness"
#     max_interval_in_seconds = 300
#     max_staleness_prefix    = 100000
#   }
#   lifecycle {
#     prevent_destroy = true  # Empêche la destruction accidentelle
#   }
#   depends_on = [
#     azurerm_resource_group.rg
#   ]
# }


# resource "azurerm_cosmosdb_sql_database" "main" {
#   name                = "api-cosmos-sqldb"
#   resource_group_name = azurerm_resource_group.rg.name
#   account_name        = azurerm_cosmosdb_account.cosmosdb_account.name
# }

# resource "azurerm_cosmosdb_sql_container" "main" {
#   name                = "api-cosmos-sqlcontainer"
#   resource_group_name = azurerm_resource_group.rg.name
#   account_name        = azurerm_cosmosdb_account.cosmosdb_account.name
#   database_name       = azurerm_cosmosdb_sql_database.main.name
#   partition_key_paths  = ["/definition/id"]
#   partition_key_version = 1

#   indexing_policy {
#     indexing_mode = "consistent"

#     included_path {
#       path = "/*"
#     }

#     included_path {
#       path = "/included/?"
#     }

#     excluded_path {
#       path = "/excluded/?"
#     }
#   }

#   unique_key {
#     paths = ["/definition/idlong", "/definition/idshort"]
#   }

# }

# Création d'un Storage Account pour le stockage Blob
resource "azurerm_storage_account" "storage_account" {
  name                     = "accountstorageapicc"
  resource_group_name       = azurerm_resource_group.rg.name
  location                 = var.location
  account_tier             = "Standard"
  account_replication_type = "LRS"

  tags = {
    environment = "Production"
  }
}

# Création d'un Container Blob dans le Storage Account
resource "azurerm_storage_container" "blob_container" {
  name                  = "blob-container-api-cc"
  storage_account_name  = azurerm_storage_account.storage_account.name
  container_access_type = "private"
}

# Création d'un Blob (fichier) dans le Container
resource "azurerm_storage_blob" "my_blob" {
  name                   = "image.png"  # Nom du fichier
  storage_account_name   = azurerm_storage_account.storage_account.name
  storage_container_name = azurerm_storage_container.blob_container.name
  type                   = "Block"
  source                 = "C:/Users/Antoine MIGNIEN/Documents/GitHub/API-Cloud-Computing/image.png"  # Chemin vers le fichier source sur votre machine
}



resource "azurerm_service_plan" "appservice-plan" {
  name                = "appservice-plan-api-cc"
  resource_group_name = azurerm_resource_group.rg.name
  location            = var.location
  os_type             = "Linux"
  sku_name            = "B1"
}

resource "azurerm_linux_web_app" "linux-web-app" {
  name                = "${random_pet.cosmosdb_name.id}-linux-web-app"
  resource_group_name = azurerm_resource_group.rg.name
  location            = var.location
  service_plan_id     = azurerm_service_plan.appservice-plan.id
  site_config {
    application_stack {
      python_version = "3.12"
    }
  }
}

resource "azurerm_app_service_source_control" "source_control" {
  app_id                 = azurerm_linux_web_app.linux-web-app.id
  repo_url               = var.github_repo_link
  branch                 = "main"
  use_manual_integration = true
}

resource "azurerm_source_control_token" "source_control_token" {
  type         = "GitHub"
  token        = var.github_auth_token
  token_secret = var.github_auth_token
}