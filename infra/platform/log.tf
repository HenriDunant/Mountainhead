resource "azurerm_log_analytics_workspace" "platform" {
  name                = "law-platform-core"
  location            = var.location
  resource_group_name = local.platform_rg_name
  sku                 = "PerGB2018"
  retention_in_days   = 30 # cost-sane default
  daily_quota_gb      = 1  # cap to prevent runaway cost; adjust later
  tags                = var.tags
}

output "log_analytics_workspace_id" {
  value = azurerm_log_analytics_workspace.platform.id
}
