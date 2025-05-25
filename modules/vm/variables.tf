variable "location" {
  description = "Azure region"
  default     = "East US"
}
variable "vm_admin_username" {
  description = "Admin username for the Virtual Machine"
  type        = string
  default     = "azadmin"
}
variable "vm_admin_password" {
  description = "The admin password for the Virtual Machine"
  type        = string
  sensitive   = true
}
variable "vm_computer_name" {
  description = "The computer name for the Virtual Machine"
  type        = string
}
variable "vm_address_space" {
  description = "The address space for the Virtual Machine"
  type        = string  
}
variable "vm_address_prefixes" {
  description = "The address prefixes for the Virtual Machine"
  type        = string
}