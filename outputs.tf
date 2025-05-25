// Outputs file

# output "vm_public_ip" {
#   description = "Public IP of the Virtual Machine"
#   value       = module.vm.vm_public_ip
# }

output "k8s_cluster_name" {
  description = "Name of the Kubernetes cluster"
  value       = module.k8s.k8s_cluster_name
}
