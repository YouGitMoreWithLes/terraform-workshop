module "storage-account-1" {
    source = "./modules/storage-account-module"

    resource_group = {
        name = data.azurerm_resource_group.rg.name
        location = data.azurerm_resource_group.rg.location
    }
    
    base_name = format("%s%s", local.short-name, "1")
}

module "storage-account-2" {
    source = "./modules/storage-account-module"
    
    resource_group = {
        name = data.azurerm_resource_group.rg.name
        location = data.azurerm_resource_group.rg.location
    }
    
    base_name = format("%s%s", local.short-name, "2")
}

module "storage-account-3" {
    source = "./modules/storage-account-module"
    
    resource_group = {
        name = data.azurerm_resource_group.rg.name
        location = data.azurerm_resource_group.rg.location
    }
    
    base_name = format("%s%s", local.short-name, "3")
}

module "storage-account-4" {
    source = "./modules/storage-account-module"
    
    resource_group = {
        name = data.azurerm_resource_group.rg.name
        location = data.azurerm_resource_group.rg.location
    }
    
    base_name = format("%s%s", local.short-name, "4")
    
    network_config = {
        enable_public_access = "false"
        virtual_network_subnet_ids = [ "{some subnet id}" ]
    }
}
