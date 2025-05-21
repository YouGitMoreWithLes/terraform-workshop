resource "azurerm_key_vault" "key-vault" {
  name                        = format("%s-%s", local.base-name, "kv")
  resource_group_name         = data.azurerm_resource_group.rg.name
  location                    = data.azurerm_resource_group.rg.location
  tenant_id                   = var.tenantId

  enable_rbac_authorization = true
  enabled_for_deployment = true

  enabled_for_disk_encryption = true
  soft_delete_retention_days  = 7
  purge_protection_enabled    = false

  sku_name = "standard"
}

data "azurerm_client_config" "usr" {}

resource "azurerm_role_assignment" "crnt_usr_kv_admin" {
  scope                = azurerm_key_vault.key-vault.id
  role_definition_name = "Key Vault Administrator"
  principal_id         = data.azurerm_client_config.usr.object_id

  description = "Key Vault Administrator for IaC user context"
}

resource "azurerm_key_vault_secret" "ehn-salesforce-secret" {

  name  = "eventhubconnectionstring-salesforce"
  value = "This is my secret"

  key_vault_id = azurerm_key_vault.key-vault.id
}