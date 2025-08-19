locals {
  admin_password = coalesce(var.admin_password, random_password.pg.result)
}

resource "random_password" "pg" {
  length  = 20
  special = true
}

resource "azurerm_postgresql_flexible_server" "this" {
  name                   = var.name
  resource_group_name    = var.rg_name
  location               = var.location
  version                = var.version
  sku_name               = var.sku_name
  storage_mb             = var.storage_mb
  administrator_login    = var.admin_login
  administrator_password = local.admin_password
  zone                   = "1"

  public_network_access_enabled = var.public_access

  authentication {
    password_auth_enabled = true
  }


  tags = var.tags
}

resource "azurerm_postgresql_flexible_database" "db" {
  name      = var.database_name
  server_id = azurerm_postgresql_flexible_server.this.id
  charset   = "UTF8"
  collation = "en_US.utf8"
}

# Allow Azure services (simple dev path). For production use Private VNet rules instead.
resource "azurerm_postgresql_flexible_server_firewall_rule" "allow_azure" {
  name      = "allow-azure"
  server_id = azurerm_postgresql_flexible_server.this.id
  start_ip_address = "0.0.0.0"
  end_ip_address   = "0.0.0.0"
}

# Connection string for your app (psycopg v3 driver, sslmode=require)
locals {
  db_url = "postgresql+psycopg://${var.admin_login}:${urlencode(local.admin_password)}@${azurerm_postgresql_flexible_server.this.fqdn}:5432/${var.database_name}?sslmode=require"
}
