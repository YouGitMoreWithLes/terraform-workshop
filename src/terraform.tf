terraform {
  
  required_version = ">= 1.10.0"

  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = ">=4.23.0"
    }

    azuread = {
      source  = "hashicorp/azuread"
      version = ">= 3.1.0"
    }
  }

#   backend "azurerm" {
#     subscription_id = "00000000-0000-0000-0000-000000000000"
#     resource_group_name  = "shared-keep-rg"
#     storage_account_name = "sharedtfstatesa"
#     container_name       = "tfws-state"
#     key                  = "tfws-state.local.tfstate"
#   }
}
