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
  default     = "https://github.com/AntoineMIGNIEN/API-Cloud-Computing.git"
  description = "GitHub repository link"
}


variable "github_auth_token" {
  type        = string
  default     = "YourGitHubToken"
  description = "GitHub personal access token"
  
}

