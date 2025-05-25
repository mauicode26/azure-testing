variable "resource_group_name" {
  description = "Name of the resource group"
  type        = string
}

variable "location" {
  description = "Azure region"
  type        = string
}

variable "registry_name" {
  description = "Name of the container registry"
  type        = string
  validation {
    condition     = can(regex("^[a-zA-Z0-9]+$", var.registry_name))
    error_message = "Registry name must contain only alphanumeric characters."
  }
}

variable "sku" {
  description = "SKU for the container registry"
  type        = string
  default     = "Basic"
  validation {
    condition     = contains(["Basic", "Standard", "Premium"], var.sku)
    error_message = "SKU must be Basic, Standard, or Premium."
  }
}

variable "admin_enabled" {
  description = "Enable admin user for the registry"
  type        = bool
  default     = true
}

variable "tags" {
  description = "Tags for the resources"
  type        = map(string)
  default     = {}
}
