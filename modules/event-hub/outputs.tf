output "connection_string" {
  description = "Connection string for Event Hub namespace"
  value       = azurerm_eventhub_namespace.namespace.default_primary_connection_string
  sensitive   = true
}

output "namespace_name" {
  description = "Name of the Event Hub namespace"
  value       = azurerm_eventhub_namespace.namespace.name
}

output "namespace_id" {
  description = "ID of the Event Hub namespace"
  value       = azurerm_eventhub_namespace.namespace.id
}

output "event_hub_names" {
  description = "Names of the created Event Hubs"
  value       = { for k, v in azurerm_eventhub.event_hubs : k => v.name }
}

output "event_hub_ids" {
  description = "IDs of the created Event Hubs"
  value       = { for k, v in azurerm_eventhub.event_hubs : k => v.id }
}
