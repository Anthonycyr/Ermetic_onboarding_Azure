provider "azurerm" {
    features {}
}

# get available subs
data "azurerm_subscriptions" "available" {
}

###########################################
#store each subs in a var
locals {
  subscriptions_map = {
    for obj in data.azurerm_subscriptions.available.subscriptions.* : obj.display_name => obj
  }
  application_id = "d4bba84d-36bf-42d3-b453-5bdd005ec6b0"
}
#get each subs id for each subs name
data "azurerm_subscription" "sub" {
  for_each = local.subscriptions_map
  subscription_id     = each.value.subscription_id
}
###########################################
data "azurerm_client_config" "ermetic_config" {}

resource "azurerm_role_assignment" "ermetic_assignment_1" {
  for_each = local.subscriptions_map
  scope                = each.value.id
  role_definition_name = "Reader"
  principal_id = data.azuread_service_principal.ermetic.object_id
}
resource "azurerm_role_assignment" "ermetic_assignment_2" {
  for_each = local.subscriptions_map
  scope                = each.value.id
  role_definition_name = "Key Vault Reader"
  principal_id = data.azuread_service_principal.ermetic.object_id
}
resource "azurerm_role_assignment" "ermetic_assignment_3" {
  for_each = local.subscriptions_map
  scope                = each.value.id
  role_definition_name = "Azure Kubernetes Service Cluster User Role"
  principal_id = data.azuread_service_principal.ermetic.object_id
}
resource "azurerm_role_assignment" "ermetic_assignment_4" {
  for_each = local.subscriptions_map
  scope                = each.value.id
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
