locals {
  platform_rg_name = azurerm_resource_group.platform_shared.name
  scope_sub        = "/subscriptions/${var.subscription_id}"
}
