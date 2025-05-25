# Azure Storage Account module for blob storage and data persistence

resource "azurerm_storage_account" "app_storage" {
  name                     = var.storage_account_name
  resource_group_name      = var.resource_group_name
  location                 = var.location
  account_tier             = var.account_tier
  account_replication_type = var.account_replication_type
  
  tags = var.tags
}

resource "azurerm_storage_container" "containers" {
  for_each              = toset(var.container_names)
  name                  = each.key
  storage_account_name  = azurerm_storage_account.app_storage.name
  container_access_type = var.container_access_type
}
