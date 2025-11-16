# Phase 0: simple seed RG to validate provider, backend, and tagging
resource "azurerm_resource_group" "platform_shared" {
  name     = "rg-platform-shared"
  location = var.location
  tags     = var.tags
}

output "platform_shared_rg" {
  value       = azurerm_resource_group.platform_shared.name
  description = "Name of the seed resource group created in Phase 0"
}

output "acr_name" {
  value = azurerm_container_registry.platform.name
}

output "key_vault_name" {
  value = azurerm_key_vault.platform.name
}
