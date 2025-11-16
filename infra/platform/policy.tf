############################################
# Policy: definitions + subscription assigns
# Compatible with azurerm >= v4
############################################

# Build the full subscription resource ID from the GUID you pass in
locals {
  subscription_resource_id = "/subscriptions/${var.subscription_id}"
}

#############################
# Custom policy definitions #
#############################

# Deny resources outside approved locations
resource "azurerm_policy_definition" "allowed_locations" {
  name         = "allowed-locations-platform"
  display_name = "Allowed locations (platform)"
  policy_type  = "Custom"
  mode         = "All"

  # Parameter is defined here; actual values are provided at assignment time
  parameters = jsonencode({
    allowedLocations = {
      type         = "Array"
      metadata     = { displayName = "Allowed locations" }
      defaultValue = ["southeastasia", "eastasia"]
    }
  })

  policy_rule = jsonencode({
    if = {
      not = {
        field = "location"
        in    = "[parameters('allowedLocations')]"
      }
    }
    then = { effect = "Deny" }
  })
}

# Require a tag on all (non-RG) resources. Effect defaults to Audit.
resource "azurerm_policy_definition" "require_tag" {
  name         = "require-tag-platform"
  display_name = "Require a tag on resources (platform)"
  policy_type  = "Custom"
  mode         = "Indexed"

  parameters = jsonencode({
    tagName = {
      type         = "String"
      metadata     = { displayName = "Tag name" }
      defaultValue = "costCenter"
    }
    effect = {
      type          = "String"
      metadata      = { displayName = "Effect" }
      defaultValue  = "Audit"
      allowedValues = ["Audit", "Deny"]
    }
  })

  policy_rule = jsonencode({
    if = {
      allOf = [
        { field = "type", notEquals = "Microsoft.Resources/subscriptions/resourceGroups" },
        { field = "[concat('tags[', parameters('tagName'), ']')]", exists = false }
      ]
    }
    then = { effect = "[parameters('effect')]" }
  })
}

#####################################
# Subscription-scope policy assigns #
#####################################

# Assign allowed locations at subscription scope, passing your allowed list
resource "azurerm_subscription_policy_assignment" "allowed_locations" {
  name                 = "allowed-locations-platform"
  display_name         = "Allowed locations (platform)"
  subscription_id      = local.subscription_resource_id
  policy_definition_id = azurerm_policy_definition.allowed_locations.id

  parameters = jsonencode({
    allowedLocations = { value = var.allowed_locations }
  })
}

# Assign the "require tag" policy (costCenter by default) at subscription scope
resource "azurerm_subscription_policy_assignment" "require_tag" {
  name                 = "require-tag-platform"
  display_name         = "Require tag: costCenter (platform)"
  subscription_id      = local.subscription_resource_id
  policy_definition_id = azurerm_policy_definition.require_tag.id

  parameters = jsonencode({
    tagName = { value = "costCenter" }
    effect  = { value = "Audit" }
  })
}
