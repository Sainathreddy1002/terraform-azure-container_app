output "host"      { value = azurerm_postgresql_flexible_server.this.fqdn }
output "database"  { value = azurerm_postgresql_flexible_database.db.name }
output "username"  { value = var.admin_login }
output "password" {
  value     = coalesce(var.admin_password, random_password.pg.result)
  sensitive = true
}
output "db_url" {
  value     = local.db_url
  sensitive = true
}