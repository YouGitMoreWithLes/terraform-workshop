locals {
    base-name = format("%s-%s", var.project_name, var.env) # "tfws-local"
    short-name = format("%s%s", var.project_name, var.env) # "tfwslocal"

    rg = {    
        name = format("%s-%s", local.base-name, "rg")
        location = var.rg_location
    }
}
