// Module for monitoring infrastructure (Grafana, Prometheus)

resource "azurerm_resource_group" "monitoring_rg" {
  name     = "monitoring-rg"
  location = var.location
}

// Storage for Grafana data
resource "azurerm_storage_account" "grafana_storage" {
  name                     = "grafanastorage${random_string.suffix.result}"
  resource_group_name      = azurerm_resource_group.monitoring_rg.name
  location                 = azurerm_resource_group.monitoring_rg.location
  account_tier             = "Standard"
  account_replication_type = "LRS"
}

resource "azurerm_storage_container" "grafana_data" {
  name                  = "grafana-data"
  storage_account_name  = azurerm_storage_account.grafana_storage.name
  container_access_type = "private"
}

// Random suffix for unique naming
resource "random_string" "suffix" {
  length  = 8
  special = false
  upper   = false
}

// Log Analytics Workspace for Azure Monitor
resource "azurerm_log_analytics_workspace" "monitoring" {
  name                = "monitoring-workspace"
  location            = azurerm_resource_group.monitoring_rg.location
  resource_group_name = azurerm_resource_group.monitoring_rg.name
  sku                 = "PerGB2018"
  retention_in_days   = 30
}

// Application Insights
resource "azurerm_application_insights" "app_insights" {
  name                = "${var.customer}-app-insights"
  location            = azurerm_resource_group.monitoring_rg.location
  resource_group_name = azurerm_resource_group.monitoring_rg.name
  workspace_id        = azurerm_log_analytics_workspace.monitoring.id
  application_type    = "web"
}
