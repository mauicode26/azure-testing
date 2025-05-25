variable "resource_group_name" {
  description = "Name of the resource group"
  type        = string
}

variable "location" {
  description = "Azure region"
  type        = string
}

variable "namespace_name" {
  description = "Name of the Event Hub namespace"
  type        = string
}

variable "sku" {
  description = "SKU for the Event Hub namespace"
  type        = string
  default     = "Basic"
  validation {
    condition     = contains(["Basic", "Standard"], var.sku)
    error_message = "SKU must be either Basic or Standard."
  }
}

variable "capacity" {
  description = "Capacity for the Event Hub namespace"
  type        = number
  default     = 1
  validation {
    condition     = var.capacity >= 1 && var.capacity <= 20
    error_message = "Capacity must be between 1 and 20."
  }
}

variable "event_hubs" {
  description = "Map of Event Hubs to create"
  type = map(object({
    partition_count   = number
    message_retention = number
  }))
  default = {}
}

variable "tags" {
  description = "Tags for the resources"
  type        = map(string)
  default     = {}
}
