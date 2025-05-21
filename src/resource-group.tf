resource "azurerm_resource_group" "deployment-rg" {
  count    = var.should_create_rg == true ? 1 : 0

  name     = local.rg.name
  location = local.rg.location
}

data azurerm_resource_group "rg" {
  depends_on = [ azurerm_resource_group.deployment-rg ]
  name     = local.rg.name
}
