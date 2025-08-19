variable "prefix" {
  type        = string
  description = "Project prefix, e.g. 'fitapp'"
}

variable "environment" {
  type        = string
  description = "Deployment environment, e.g. 'dev', 'stg', 'prod'"
}

variable "location" {
  type        = string
  default     = "eastus"
  description = "Azure region"
}

variable "tags" {
  type        = map(string)
  default     = {}
  description = "Common resource tags"
}

# ---------------- Container image (already pushed to ACR) ----------------
variable "container_image_name" {
  type        = string
  description = "Image name in ACR (repository), e.g. 'fitapp-api'"
}

variable "container_image_tag" {
  type        = string
  default     = "latest"
  description = "Image tag"
}

# ---------------- Sizing ----------------
variable "container_cpu" {
  type    = number
  default = 0.5
}

variable "container_memory" {
  type    = string
  default = "1.0Gi"
}

variable "min_replicas" {
  type    = number
  default = 1
}

variable "max_replicas" {
  type    = number
  default = 1
}

# ---------------- PostgreSQL ----------------
variable "pg_version" {
  type    = string
  default = "16"
}

variable "pg_sku_name" {
  type    = string
  default = "B_Standard_B1ms" # burstable
}

variable "pg_storage_mb" {
  type    = number
  default = 32768             # 32GB
}

variable "pg_admin_login" {
  type    = string
  default = "fitappadmin"
}

variable "pg_admin_password" {
  type        = string
  default     = null          # if null, a random password will be generated
  sensitive   = true
  description = "Optional admin password; set to null to auto-generate"
}

variable "pg_public_access" {
  type    = bool
  default = true              # keep true for simplicity; private is possible
}

# ---------------- Ingress ----------------
variable "app_port" {
  type    = number
  default = 8030              # your app listens here
}

variable "ingress_external" {
  type    = bool
  default = true              # public HTTP ingress
}
