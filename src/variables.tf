variable "tenantId" {
  type    = string
  default = "00000000-0000-0000-0000-000000000000"
}
variable "subscriptionId" {
    type = string
    description = "My subscription"
    default = "00000000-0000-0000-0000-000000000000"
}

variable "project_name" {
  type    = string
  default = "tfws"
}

variable "env" {
  type    = string
  default = "local"
}

variable "resource_group_name" {
    type = string
    default = "my_rg"
}

variable "rg_location" {
  type    = string
  default = "westus3"
}

variable "should_create_rg" {
  type    = bool
  default = true
}
