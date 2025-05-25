// Module for Kubernetes-related resources

resource "azurerm_resource_group" "k8s_rg" {
  name     = "k8s-resource-group"
  location = "eastus"
}

resource "azurerm_kubernetes_cluster" "k8s_cluster" {
  name                = "k8s-cluster"
  location            = azurerm_resource_group.k8s_rg.location
  resource_group_name = azurerm_resource_group.k8s_rg.name
  dns_prefix          = "k8s"

  default_node_pool {
    name       = "default"
    node_count = 1
    vm_size    = "Standard_A2_v2"
  }

  identity {
    type = "SystemAssigned"
  }

  tags = {
    Environment = "Production"
  }
}
