provider "azurerm" {
  features {}

  # 1) Pull from TF var (we also export ENV above as a belt-and-suspenders)
  subscription_id = var.subscription_id
  tenant_id       = "d5f50de4-601e-41b9-9b73-4696764eb104"
}
