output "k8s_cluster_name" {
  description = "Name of the Kubernetes cluster"
  value       = azurerm_kubernetes_cluster.k8s_cluster.name
}