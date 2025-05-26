
variable "server_name" {
  description = "The name of the MSSQL server"
  type        = string
}

variable "resource_group_name" {
  description = "The name of the resource group"
  type        = string
}

variable "location" {
  description = "The Azure region where resources will be created"
  type        = string
}

variable "db_version" {
  description = "The version of the MSSQL server"
  type        = string
  default     = "12.0"
}

variable "administrator_login" {
  description = "The administrator login for the MSSQL server"
  type        = string
}

variable "administrator_login_password" {
  description = "The administrator password for the MSSQL server"
  type        = string
  sensitive   = true
}

variable "database_name" {
  description = "The name of the database to create"
  type        = string
}

variable "sku_name" {
  description = "The SKU name for the database"
  type        = string
  default     = "S0"
}

variable "max_size_gb" {
  description = "The maximum size of the database in GB"
  type        = number
  default     = 2
}

variable "collation" {
  description = "The collation of the database"
  type        = string
  default     = "SQL_Latin1_General_CP1_CI_AS"
}

variable "tags" {
  description = "A map of tags to assign to the resources"
  type        = map(string)
  default     = {}
}

variable "public_network_access_enabled" {
  description = "Whether public network access is enabled for the server"
  type        = bool
  default     = true
}

variable "minimum_tls_version" {
  description = "The minimum TLS version for the server"
  type        = string
  default     = "1.2"
}
