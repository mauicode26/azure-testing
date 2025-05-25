output "storage_account_name" {
  description = "Storage account name"
  value       = azurerm_storage_account.app_storage.name
}

output "storage_account_id" {
  description = "Storage account ID"
  value       = azurerm_storage_account.app_storage.id
}

output "storage_account_primary_access_key" {
  description = "Storage account primary access key"
  value       = azurerm_storage_account.app_storage.primary_access_key
  sensitive   = true
}

output "storage_account_secondary_access_key" {
  description = "Storage account secondary access key"
  value       = azurerm_storage_account.app_storage.secondary_access_key
  sensitive   = true
}

output "storage_account_primary_connection_string" {
  description = "Storage account primary connection string"
  value       = azurerm_storage_account.app_storage.primary_connection_string
  sensitive   = true
}

output "storage_account_secondary_connection_string" {
  description = "Storage account secondary connection string"
  value       = azurerm_storage_account.app_storage.secondary_connection_string
  sensitive   = true
}

output "storage_account_primary_blob_endpoint" {
  description = "Storage account primary blob endpoint"
  value       = azurerm_storage_account.app_storage.primary_blob_endpoint
}

output "container_names" {
  description = "Names of created containers"
  value       = [for container in azurerm_storage_container.containers : container.name]
}
