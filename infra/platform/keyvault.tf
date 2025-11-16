resource "azurerm_key_vault" "platform" {
  name                = "kv-${replace(local.platform_rg_name, "rg-", "")}"
  location            = var.location
  resource_group_name = local.platform_rg_name
  tenant_id           = data.azurerm_client_config.current.tenant_id
  sku_name            = "standard"

  rbac_authorization_enabled = true
  soft_delete_retention_days = 14
  purge_protection_enabled   = true

  tags = var.tags
}

data "azurerm_client_config" "current" {}
