// Module for additional Azure services (Event Hub, Redis, DNS, Container Registry)

resource "azurerm_resource_group" "services_rg" {
  name     = "azure-services-rg"
  location = var.location
}

// Azure Container Registry
resource "azurerm_container_registry" "acr" {
  name                = "seanshickeyacr"
  resource_group_name = azurerm_resource_group.services_rg.name
  location            = azurerm_resource_group.services_rg.location
  sku                 = "Basic"
  admin_enabled       = true
}

// Azure Event Hub Namespace
resource "azurerm_eventhub_namespace" "vehicle_events" {
  name                = "vehicle-events-namespace"
  location            = azurerm_resource_group.services_rg.location
  resource_group_name = azurerm_resource_group.services_rg.name
  sku                 = "Basic"
  capacity            = 1
}

// Event Hub for vehicle telemetry
resource "azurerm_eventhub" "vehicle_telemetry" {
  name                = "vehicle-telemetry"
  namespace_name      = azurerm_eventhub_namespace.vehicle_events.name
  resource_group_name = azurerm_resource_group.services_rg.name
  partition_count     = 2
  message_retention   = 1
}

// Azure Redis Cache
resource "azurerm_redis_cache" "app_cache" {
  name                = "seanshickey-redis"
  location            = azurerm_resource_group.services_rg.location
  resource_group_name = azurerm_resource_group.services_rg.name
  capacity            = 0
  family              = "C"
  sku_name            = "Basic"
  enable_non_ssl_port = false
  minimum_tls_version = "1.2"
}

// Azure Blob Storage for data persistence
resource "azurerm_storage_account" "app_storage" {
  name                     = "seanshickeyappstorage"
  resource_group_name      = azurerm_resource_group.services_rg.name
  location                 = azurerm_resource_group.services_rg.location
  account_tier             = "Standard"
  account_replication_type = "LRS"
}

resource "azurerm_storage_container" "vehicle_data" {
  name                  = "vehicle-data"
  storage_account_name  = azurerm_storage_account.app_storage.name
  container_access_type = "private"
}

// DNS Zone for seanshickey.com
resource "azurerm_dns_zone" "main" {
  name                = "seanshickey.com"
  resource_group_name = azurerm_resource_group.services_rg.name
}

// A records for applications
resource "azurerm_dns_a_record" "vehicle_dashboard" {
  name                = "vehicle-dashboard"
  zone_name           = azurerm_dns_zone.main.name
  resource_group_name = azurerm_resource_group.services_rg.name
  ttl                 = 300
  records             = ["20.62.156.234"] # Will be updated with actual LoadBalancer IP
}

resource "azurerm_dns_a_record" "loan_api" {
  name                = "loan-api"
  zone_name           = azurerm_dns_zone.main.name
  resource_group_name = azurerm_resource_group.services_rg.name
  ttl                 = 300
  records             = ["20.62.156.235"] # Will be updated with actual LoadBalancer IP
}

resource "azurerm_dns_a_record" "api_gateway" {
  name                = "api"
  zone_name           = azurerm_dns_zone.main.name
  resource_group_name = azurerm_resource_group.services_rg.name
  ttl                 = 300
  records             = ["20.62.156.236"] # Will be updated with actual LoadBalancer IP
}
