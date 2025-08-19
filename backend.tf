terraform {
  backend "azurerm" {
    resource_group_name  = "tfstate-rg"
    storage_account_name = "stfitapptfstate1234"   # globally unique
    container_name       = "tfstate"
    key                  = "containerapp/dev/terraform.tfstate"
    use_azuread_auth     = true
  }
}