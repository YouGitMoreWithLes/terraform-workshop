variable "resource_group" {
  type = object({
    name = string
    location = string
  })
}

variable "base_name" {
  type = string
}

variable "network_config" {
  type = object({
    enable_public_access = string
    virtual_network_subnet_ids = list(string)
  })
  default = {
    enable_public_access = "true"
    virtual_network_subnet_ids = []
  }
}

resource "azurerm_storage_account" "content-sa" {
  name                     =  "${var.base_name}sa"

  resource_group_name      = var.resource_group.name
  location                 = var.resource_group.location
  
  account_tier             = "Standard"
  account_replication_type = "LRS"

  identity {
    type = "SystemAssigned"
  }

  // Networking and access control
  public_network_access_enabled = var.network_config.enable_public_access
  shared_access_key_enabled = true
  https_traffic_only_enabled = true
  min_tls_version = "TLS1_2"

dynamic "network_rules" {
    for_each = var.network_config.enable_public_access == "true" ? [1] : []
    content {
      default_action = "Deny"
      bypass                     = ["AzureServices"]
      virtual_network_subnet_ids = var.network_config.virtual_network_subnet_ids
    }
  }
}