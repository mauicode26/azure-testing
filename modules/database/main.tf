resource "azurerm_mssql_server" "mssql_server" {
    name                         = var.server_name
    resource_group_name          = var.resource_group_name
    location                     = var.location
    version                      = var.db_version
    administrator_login          = var.administrator_login
    administrator_login_password = var.administrator_login_password
    minimum_tls_version          = var.minimum_tls_version
    public_network_access_enabled = var.public_network_access_enabled
    tags = var.tags
}

resource "azurerm_mssql_database" "mssql_database" {
    name                = var.database_name
    server_id           = azurerm_mssql_server.mssql_server.id
    collation           = var.collation
    max_size_gb         = var.max_size_gb
    sku_name            = var.sku_name
    tags = var.tags
}

# Firewall rule to allow Azure services
resource "azurerm_mssql_firewall_rule" "allow_azure_services" {
    name             = "AllowAzureServices"
    server_id        = azurerm_mssql_server.mssql_server.id
    start_ip_address = "0.0.0.0"
    end_ip_address   = "0.0.0.0"
}