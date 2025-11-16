resource "azurerm_container_registry" "platform" {
  name                = "acr${replace(local.platform_rg_name, "-", "")}core"
  resource_group_name = local.platform_rg_name
  location            = var.location
  sku                 = "Basic"
  admin_enabled       = false
  tags                = var.tags
}

output "acr_login_server" {
  value = azurerm_container_registry.platform.login_server
}
