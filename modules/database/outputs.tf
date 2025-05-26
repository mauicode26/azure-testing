
output "server_id" {
  description = "The ID of the MSSQL server"
  value       = azurerm_mssql_server.mssql_server.id
}

output "server_name" {
  description = "The name of the MSSQL server"
  value       = azurerm_mssql_server.mssql_server.name
}

output "server_fqdn" {
  description = "The fully qualified domain name of the MSSQL server"
  value       = azurerm_mssql_server.mssql_server.fully_qualified_domain_name
}

output "database_id" {
  description = "The ID of the MSSQL database"
  value       = azurerm_mssql_database.mssql_database.id
}

output "database_name" {
  description = "The name of the MSSQL database"
  value       = azurerm_mssql_database.mssql_database.name
}

output "connection_string" {
  description = "The connection string for the database"
  value       = "Server=tcp:${azurerm_mssql_server.mssql_server.fully_qualified_domain_name},1433;Initial Catalog=${azurerm_mssql_database.mssql_database.name};Persist Security Info=False;User ID=${var.administrator_login};MultipleActiveResultSets=False;Encrypt=True;TrustServerCertificate=False;Connection Timeout=30;"
  sensitive   = true
}
