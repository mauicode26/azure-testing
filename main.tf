
# module "vm" {
#   source = "./modules/vm"
#     vm_computer_name = var.vm_computer_name
#     vm_admin_username = var.vm_admin_username
#     vm_admin_password = var.vm_admin_password
#     location         = var.location
# }


module "resource_group" {
  source              = "./modules/resource-group"
  resource_group_name = "azure-services-rg"
  location            = var.location
  tags = {
    Environment = "demo"
    Project     = "${var.customer}-devops"
  }
}

module "k8s" {
  source = "./modules/k8s"
}

module "container_registry" {
  source              = "./modules/container-registry"
  registry_name       = "seanshickeyacr"
  resource_group_name = module.resource_group.resource_group_name
  location            = module.resource_group.resource_group_location
  sku                 = "Basic"
  admin_enabled       = true
  tags = {
    Environment = "demo"
    Project     = "${var.customer}-devops"
  }
}

module "event_hub" {
  source              = "./modules/event-hub"
  namespace_name      = "vehicle-events-namespace"
  resource_group_name = module.resource_group.resource_group_name
  location            = module.resource_group.resource_group_location
  sku                 = "Basic"
  capacity            = 1
  event_hubs = {
    "vehicle-telemetry" = {
      partition_count   = 2
      message_retention = 1
    }
  }
  tags = {
    Environment = "demo"
    Project     = "${var.customer}-devops"
  }
}

# Redis Cache
module "redis_cache" {
  source              = "./modules/redis-cache"
  redis_name          = "seanshickey-redis"
  resource_group_name = module.resource_group.resource_group_name
  location            = module.resource_group.resource_group_location
  capacity            = 0
  family              = "C"
  sku_name            = "Basic"
  minimum_tls_version = "1.2"
  tags = {
    Environment = "demo"
    Project     = "${var.customer}-devops"
  }
}

# Storage Account
module "storage_account" {
  source                   = "./modules/storage-account"
  storage_account_name     = "seanshickeyappstorage"
  resource_group_name      = module.resource_group.resource_group_name
  location                 = module.resource_group.resource_group_location
  account_tier             = "Standard"
  account_replication_type = "LRS"
  container_names          = ["vehicle-data"]
  container_access_type    = "private"
  tags = {
    Environment = "demo"
    Project     = "${var.customer}-devops"
  }
}

# DNS Zone
module "dns" {
  source              = "./modules/dns"
  domain_name         = "seanshickey.com"
  resource_group_name = module.resource_group.resource_group_name
  default_ttl         = 300
  a_records = {
    "vehicle-dashboard" = {
      records = ["20.62.156.234"] # Will be updated with actual LoadBalancer IP
    }
    "loan-api" = {
      records = ["20.62.156.235"] # Will be updated with actual LoadBalancer IP
    }
    "api" = {
      records = ["20.62.156.236"] # Will be updated with actual LoadBalancer IP
    }
  }
  tags = {
    Environment = "demo"
    Project     = "${var.customer}-devops"
  }
}

module "monitoring" {
  source   = "./modules/monitoring"
  location = var.location
}
