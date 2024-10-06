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

variable "github_repo_link" {
  type        = string
  default     = "GITHUB_REPO_LINK"
  description = "GitHub repository link"
}


variable "github_auth_token" {
  type        = string
  default     = "GITHUB_AUTH_TOKEN"
  description = "GitHub personal access token"
  
}

