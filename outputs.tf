// Outputs file

# output "vm_public_ip" {
#   description = "Public IP of the Virtual Machine"
#   value       = module.vm.vm_public_ip
# }

output "k8s_cluster_name" {
  description = "Name of the Kubernetes cluster"
  value       = module.k8s.k8s_cluster_name
}

# Resource Group outputs
output "resource_group_name" {
  description = "Name of the main resource group"
  value       = module.resource_group.resource_group_name
}

# Container Registry outputs
output "acr_login_server" {
  description = "Login server URL for Azure Container Registry"
  value       = module.container_registry.login_server
}

output "acr_admin_username" {
  description = "Admin username for Azure Container Registry"
  value       = module.container_registry.admin_username
}

output "acr_admin_password" {
  description = "Admin password for Azure Container Registry"
  value       = module.container_registry.admin_password
  sensitive   = true
}

# Event Hub outputs
output "eventhub_connection_string" {
  description = "Connection string for Event Hub"
  value       = module.event_hub.connection_string
  sensitive   = true
}

# Redis Cache outputs
output "redis_hostname" {
  description = "Redis cache hostname"
  value       = module.redis_cache.hostname
}

output "redis_primary_key" {
  description = "Redis cache primary access key"
  value       = module.redis_cache.primary_access_key
  sensitive   = true
}

# Storage Account outputs
output "storage_account_name" {
  description = "Storage account name"
  value       = module.storage_account.storage_account_name
}

output "storage_account_primary_access_key" {
  description = "Storage account access key"
  value       = module.storage_account.storage_account_primary_access_key
  sensitive   = true
}

# DNS outputs
output "dns_zone_name_servers" {
  description = "Name servers for the DNS zone"
  value       = module.dns.dns_zone_name_servers
}
