terraform {
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "~>4.0.0"
    }
  }
}

# Configure the Microsoft Azure Provider
provider "azurerm" {
  features {}
  subscription_id = var.subscription_id
}

# module "vm" {
#   source = "./modules/vm"
#     vm_computer_name = var.vm_computer_name
#     vm_admin_username = var.vm_admin_username
#     vm_admin_password = var.vm_admin_password
#     location         = var.location
# }

module "k8s" {
  source = "./modules/k8s"
}

module "azure_services" {
  source   = "./modules/azure-services"
  location = var.location
}

module "monitoring" {
  source   = "./modules/monitoring"
  location = var.location
}
