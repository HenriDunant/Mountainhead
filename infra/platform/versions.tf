terraform {
  required_version = ">= 1.5.0"
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = ">= 4.0.0"
    }
  }

  # Tell Terraform we use the azurerm backend (values come from backend.hcl at init)
  backend "azurerm" {}
}
