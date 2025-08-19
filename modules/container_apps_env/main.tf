resource "azurerm_container_app_environment" "this" {
  name                = var.name
  location            = var.location
  resource_group_name = var.rg_name

  log_analytics_workspace_id = var.log_analytics_id
  tags = var.tags
}