locals {
  tags = merge({ application = var.application, environment = var.environment }, var.tags)
}

data "azurerm_client_config" "current" {}

resource "azurerm_key_vault" "this" {
  name                = coalesce(var.key_vault_name, "kv-${var.application}-${var.environment}")
  location            = var.location
  resource_group_name = var.resource_group_name
  sku_name            = "standard"
  tenant_id           = data.azurerm_client_config.current.tenant_id

  soft_delete_retention_days = 90
  purge_protection_enabled   = false

  enabled_for_deployment          = false
  enabled_for_disk_encryption     = false
  enabled_for_template_deployment = false

  enable_rbac_authorization = false

  tags = local.tags
}

resource "azurerm_key_vault_access_policy" "this" {
  key_vault_id = azurerm_key_vault.this.id
  tenant_id    = data.azurerm_client_config.current.tenant_id
  object_id    = data.azurerm_client_config.current.object_id

  secret_permissions      = var.client_secret_permissions
  certificate_permissions = var.client_certificate_permissions
  key_permissions         = var.client_key_permissions
}

resource "azurerm_key_vault_access_policy" "secret_readers" {
  for_each = toset(var.secret_readers)

  key_vault_id = azurerm_key_vault.this.id
  tenant_id    = data.azurerm_client_config.current.tenant_id
  object_id    = each.value

  secret_permissions      = ["Get", "List"]
  certificate_permissions = []
  key_permissions         = []
}

resource "azurerm_key_vault_access_policy" "secret_contributors" {
  for_each = toset(var.secret_contributors)

  key_vault_id = azurerm_key_vault.this.id
  tenant_id    = data.azurerm_client_config.current.tenant_id
  object_id    = each.value

  secret_permissions      = ["Get", "List"]
  certificate_permissions = []
  key_permissions         = []
}

resource "azurerm_monitor_diagnostic_setting" "this" {
  name                       = "${azurerm_key_vault.this.name}-logs"
  target_resource_id         = azurerm_key_vault.this.id
  log_analytics_workspace_id = var.log_analytics_workspace_id

  log {
    category = "AuditEvent"
    enabled  = true

    retention_policy {
      enabled = false
    }
  }

  log {
    category = "AzurePolicyEvaluationDetails"
    enabled  = false

    retention_policy {
      enabled = false
    }
  }

  metric {
    category = "AllMetrics"
    enabled  = true

    retention_policy {
      enabled = false
    }
  }
}
