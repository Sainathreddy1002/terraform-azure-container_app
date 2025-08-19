output "resource_group"        { value = module.rg.name }
output "acr_login_server"      { value = module.acr.login_server }
output "container_app_url"     { value = try(module.app.fqdn, null) }
output "postgres_fqdn"         { value = module.pg.host }
output "postgres_db"           { value = module.pg.database }
output "postgres_admin_user"   { value = module.pg.username }
# Never print password in real envs. Here we keep it hidden.
