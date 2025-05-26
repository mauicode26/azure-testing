module "resource_group" {
  source = "./modules/resource-group"
  resource_group_name = var.resource_group_name
  location            = var.location  
}

module "database" {
  source = "./modules/database"
  resource_group_name = module.resource_group.resource_group_name
  location            = var.location
  database_name       = var.database_name
  sku_name            = var.database_sku_name
  tags                = var.tags
  server_name         = var.database_server_name
  administrator_login = var.database_administrator_login
  administrator_login_password = var.database_administrator_login_password
}