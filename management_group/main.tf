provider "azurerm" {
    features {}
}

# Get Management Group
data "azurerm_management_group" "whatever" {
  name = "00000000-0000-0000-0000-000000000000"
}
###########################################
locals {
  application_id = "d4bba84d-36bf-42d3-b453-5bdd005ec6b0"
}

###########################################
data "azurerm_client_config" "ermetic_config" {}

resource "azurerm_role_assignment" "ermetic_assignment_1" {
  scope                = data.azurerm_management_group.whatever.name
  role_definition_name = "Reader"
  principal_id = data.azuread_service_principal.ermetic.object_id
}
resource "azurerm_role_assignment" "ermetic_assignment_2" {
  scope                = data.azurerm_management_group.whatever.name
  role_definition_name = "Key Vault Reader"
  principal_id = data.azuread_service_principal.ermetic.object_id
}
resource "azurerm_role_assignment" "ermetic_assignment_3" {
  scope                = data.azurerm_management_group.whatever.name
  role_definition_name = "Azure Kubernetes Service Cluster User Role"
  principal_id = data.azuread_service_principal.ermetic.object_id
}
resource "azurerm_role_assignment" "ermetic_assignment_4" {
  scope                = data.azurerm_management_group.whatever.name
  role_definition_name = "Azure Kubernetes Service RBAC Reader"
  principal_id = data.azuread_service_principal.ermetic.object_id
}

###########################################################
# AZURE AD
###########################################################

provider "azuread" {
  tenant_id =  data.azurerm_client_config.ermetic_config.tenant_id
}

resource "azuread_service_principal" "ermetic" {
  application_id = local.application_id
  use_existing   = true
}

data "azuread_service_principal" "ermetic" {
  display_name     = "Ermetic App"
  depends_on = [
    azuread_service_principal.ermetic
  ]
}

output "object_id" {
  value = data.azuread_service_principal.ermetic.object_id
}
