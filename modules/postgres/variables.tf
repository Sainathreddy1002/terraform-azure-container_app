variable "name"            { type = string }
variable "rg_name"         { type = string }
variable "location"        { type = string }
variable "version"         { type = string }
variable "sku_name"        { type = string }
variable "storage_mb"      { type = number }
variable "admin_login"     { type = string }
variable "admin_password"  { 
    type = string 
    default = null 
    sensitive = true 
    }
variable "public_access"   { type = bool }
variable "database_name"   { type = string }
variable "tags"            { type = map(string) }
