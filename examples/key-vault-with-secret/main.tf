provider "azurerm" {
  features {}
}

locals {
  app_name         = "ops-vault"
  environment_name = "example"
}

resource "azurerm_resource_group" "example" {
  name     = "rg-${local.app_name}-${local.environment_name}"
  location = "northeurope"
}

resource "azurerm_log_analytics_workspace" "example" {
  name                = "log-${local.app_name}-${local.environment_name}"
  location            = azurerm_resource_group.example.location
  resource_group_name = azurerm_resource_group.example.name
  sku                 = "Free"
}

module "vault" {
  source = "../.."

  app_name                   = local.app_name
  environment_name           = local.environment_name
  location                   = azurerm_resource_group.example.location
  resource_group_name        = azurerm_resource_group.example.name
  log_analytics_workspace_id = azurerm_log_analytics_workspace.example.id
}

resource "azurerm_key_vault_secret" "example" {
  name         = "secret-name"
  value        = "super-secret-value"
  key_vault_id = module.vault.key_vault_id
}