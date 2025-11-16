############################
# Core environment inputs  #
############################

# Required: your Azure Subscription ID.
variable "subscription_id" {
  type        = string
  description = "Azure subscription ID used by the azurerm provider and subscription-scope resources."
}

# Main deployment region (default keeps us in Southeast Asia).
variable "location" {
  type        = string
  description = "Primary Azure region for resources."
  default     = "southeastasia"

  validation {
    condition     = contains(var.allowed_locations, var.location)
    error_message = "location must be one of allowed_locations."
  }
}

# Guardrail for regions (used by policy assignment + validation above).
variable "allowed_locations" {
  type        = list(string)
  description = "List of permitted regions for this platform."
  default     = ["southeastasia", "eastasia"]
}

############################
# Naming & tagging          #
############################

# Short prefix for resource names (used in modules/files to make names consistent).
variable "name_prefix" {
  type        = string
  description = "Prefix used for naming shared resources (e.g., rg, kv, acr)."
  default     = "platform"
}

# Common tags applied to all taggable resources.
variable "tags" {
  type        = map(string)
  description = "Tags applied to all resources."
  default = {
    project     = "finops-azure-platform"
    environment = "shared"
    owner       = "you"
  }
}

############################
# Service-specific knobs    #
############################

# Log Analytics retention (days).
variable "log_analytics_retention_days" {
  type        = number
  description = "Retention in days for the Log Analytics workspace."
  default     = 30
  validation {
    condition     = var.log_analytics_retention_days >= 7 && var.log_analytics_retention_days <= 730
    error_message = "Log Analytics retention must be between 7 and 730 days."
  }
}

# Azure Container Registry SKU.
variable "acr_sku" {
  type        = string
  description = "SKU for Azure Container Registry."
  default     = "Basic"
  validation {
    condition     = contains(["Basic", "Standard", "Premium"], var.acr_sku)
    error_message = "acr_sku must be one of: Basic, Standard, Premium."
  }
}

# Key Vault SKU (v4 provider).
variable "key_vault_sku_name" {
  type        = string
  description = "Azure Key Vault SKU name."
  default     = "standard"
  validation {
    condition     = contains(["standard", "premium"], lower(var.key_vault_sku_name))
    error_message = "key_vault_sku_name must be 'standard' or 'premium'."
  }
}

