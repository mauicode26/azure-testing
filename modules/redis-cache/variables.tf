variable "resource_group_name" {
  description = "Name of the resource group"
  type        = string
}

variable "location" {
  description = "Azure region"
  type        = string
}

variable "redis_name" {
  description = "Name of the Redis cache"
  type        = string
  validation {
    condition     = can(regex("^[a-zA-Z0-9-]+$", var.redis_name))
    error_message = "Redis name must contain only alphanumeric characters and hyphens."
  }
}

variable "capacity" {
  description = "Capacity of the Redis cache"
  type        = number
  default     = 0
  validation {
    condition     = var.capacity >= 0 && var.capacity <= 6
    error_message = "Capacity must be between 0 and 6."
  }
}

variable "family" {
  description = "Redis cache family"
  type        = string
  default     = "C"
  validation {
    condition     = contains(["C", "P"], var.family)
    error_message = "Family must be either C or P."
  }
}

variable "sku_name" {
  description = "SKU name for Redis cache"
  type        = string
  default     = "Basic"
  validation {
    condition     = contains(["Basic", "Standard", "Premium"], var.sku_name)
    error_message = "SKU name must be Basic, Standard, or Premium."
  }
}

variable "minimum_tls_version" {
  description = "Minimum TLS version"
  type        = string
  default     = "1.2"
  validation {
    condition     = contains(["1.0", "1.1", "1.2"], var.minimum_tls_version)
    error_message = "Minimum TLS version must be 1.0, 1.1, or 1.2."
  }
}

variable "tags" {
  description = "Tags for the resources"
  type        = map(string)
  default     = {}
}
