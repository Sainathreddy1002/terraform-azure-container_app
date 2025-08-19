# modules/container_app/main.tf
resource "azurerm_container_app" "this" {
  name                         = var.name
  resource_group_name          = var.rg_name
  container_app_environment_id = var.env_id
  revision_mode                = "Single"
  tags                         = var.tags

  identity {
    type         = "UserAssigned"
    identity_ids = [var.identity_id]
  }

  # Pull image from ACR using the UAMI
  registry {
    server   = var.acr_server
    identity = var.identity_id
  }

  # ---- ingress must include at least one traffic_weight block ----
  ingress {
    external_enabled = var.external_ingress
    target_port      = var.target_port
    transport        = "auto"

    traffic_weight {
      latest_revision = true
      percentage      = 100
    }
  }

  # Secret for DB_URL
  secret {
    name  = var.db_url_secret_name
    value = var.db_url_secret_value
  }

  template {
    min_replicas = var.min_replicas
    max_replicas = var.max_replicas

    container {
      name   = "api"
      image  = var.image
      cpu    = var.cpu
      memory = var.memory

      # Inject DB_URL from secret
      env {
        name        = "DB_URL"
        secret_name = var.db_url_secret_name
      }

      # Extra non-secret envs (e.g., PORT)
      dynamic "env" {
        for_each = var.extra_env
        content {
          name  = env.key
          value = env.value
        }
      }
    }
  }
}
