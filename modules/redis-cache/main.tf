// Module for Azure Redis Cache

resource "azurerm_redis_cache" "cache" {
  name                = var.redis_name
  location            = var.location
  resource_group_name = var.resource_group_name
  capacity            = var.capacity
  family              = var.family
  sku_name            = var.sku_name
  minimum_tls_version = var.minimum_tls_version

  tags = var.tags
}
