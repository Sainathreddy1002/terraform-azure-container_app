variable "name"      { type = string }
variable "rg_name"   { type = string }
variable "env_id"    { type = string }
variable "identity_id" { type = string }

variable "acr_server" { type = string }
variable "image"      { type = string }

variable "cpu"        { type = number }
variable "memory"     { type = string }
variable "min_replicas" { type = number }
variable "max_replicas" { type = number }

variable "target_port"     { type = number }
variable "external_ingress"{ type = bool }

variable "db_url_secret_name"  { type = string }
variable "db_url_secret_value" { 
    type = string 
    sensitive = true 
    }

variable "extra_env" { 
      type = map(string) 
      default = {} 
      }
variable "tags"      { type = map(string) }
