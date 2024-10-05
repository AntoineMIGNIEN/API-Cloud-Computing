variable "location" {
  type        = string
  default     = "francecentral"
  description = "Azure Region where the resources will be deployed"
}

variable "cosmosdb_account_location" {
  type        = string
  default     = "francecentral"
  description = "Azure Region where the CosmosDB account will be deployed"
}

variable "cosmosdb_account_name" {
  type        = string
  default     = "api-cosmosdb"
  description = "Name of the CosmosDB account"
}

