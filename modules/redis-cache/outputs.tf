output "redis_hostname" {
  description = "Redis cache hostname"
  value       = azurerm_redis_cache.cache.hostname
}

output "redis_port" {
  description = "Redis cache port"
  value       = azurerm_redis_cache.cache.port
}

output "redis_ssl_port" {
  description = "Redis cache SSL port"
  value       = azurerm_redis_cache.cache.ssl_port
}

output "redis_primary_key" {
  description = "Redis cache primary access key"
  value       = azurerm_redis_cache.cache.primary_access_key
  sensitive   = true
}

output "redis_secondary_key" {
  description = "Redis cache secondary access key"
  value       = azurerm_redis_cache.cache.secondary_access_key
  sensitive   = true
}

output "resource_group_name" {
  description = "Name of the resource group"
  value       = azurerm_resource_group.redis_rg.name
}
