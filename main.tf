locals {
  name = "${var.prefix}-${var.environment}"
  tags = merge(var.tags, { env = var.environment })
}

module "rg" {
  source   = "./modules/resource_group"
  name     = "${local.name}-rg"
  location = var.location
  tags     = local.tags
}

module "la" {
  source   = "./modules/log_analytics"
  name     = "${local.name}-logs"
  rg_name  = module.rg.name
  location = var.location
  tags     = local.tags
}

module "acr" {
  source   = "./modules/acr"
  name     = "${local.name}acr"
  rg_name  = module.rg.name
  location = var.location
  sku      = "Standard"
  tags     = local.tags
}

module "uami" {
  source   = "./modules/managed_identity"
  name     = "${local.name}-mi"
  rg_name  = module.rg.name
  location = var.location
  tags     = local.tags
}

# Allow the Managed Identity to pull images from ACR
resource "azurerm_role_assignment" "acr_pull" {
  scope                = module.acr.id
  role_definition_name = "AcrPull"
  principal_id         = module.uami.principal_id
}

module "env" {
  source                 = "./modules/container_apps_env"
  name                   = "${local.name}-cae"
  rg_name                = module.rg.name
  location               = var.location
  log_analytics_id       = module.la.id
  tags                   = local.tags
}

module "pg" {
  source            = "./modules/postgres"
  name              = "${local.name}-pg"
  rg_name           = module.rg.name
  location          = var.location
  version           = var.pg_version
  sku_name          = var.pg_sku_name
  storage_mb        = var.pg_storage_mb
  admin_login       = var.pg_admin_login
  admin_password    = var.pg_admin_password
  public_access     = var.pg_public_access
  database_name     = "fitapp"
  tags              = local.tags
}

module "app" {
  source     = "./modules/container_app"

  name       = "${local.name}-api"
  rg_name    = module.rg.name
  env_id     = module.env.id
  identity_id= module.uami.id

  acr_server = module.acr.login_server
  image      = "${module.acr.login_server}/${var.container_image_name}:${var.container_image_tag}"

  cpu        = var.container_cpu
  memory     = var.container_memory
  min_replicas = var.min_replicas
  max_replicas = var.max_replicas
  target_port  = var.app_port
  external_ingress = var.ingress_external

  # App env vars (one secret for DB_URL, one plain for PORT)
  db_url_secret_name = "db-url"
  db_url_secret_value= module.pg.db_url
  extra_env = {
    "PORT" = tostring(var.app_port)
  }

  tags = local.tags
}
