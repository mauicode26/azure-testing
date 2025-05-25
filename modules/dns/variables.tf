variable "domain_name" {
  description = "Domain name for the DNS zone"
  type        = string
}

variable "resource_group_name" {
  description = "Name of the resource group"
  type        = string
}

variable "default_ttl" {
  description = "Default TTL for DNS records"
  type        = number
  default     = 300
}

variable "a_records" {
  description = "Map of A records to create"
  type = map(object({
    records = list(string)
  }))
  default = {}
}

variable "cname_records" {
  description = "Map of CNAME records to create"
  type = map(object({
    record = string
  }))
  default = {}
}

variable "tags" {
  description = "Tags to apply to resources"
  type        = map(string)
  default     = {}
}
