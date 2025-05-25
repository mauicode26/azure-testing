// Variables file

variable "location" {
  description = "Azure region"
  default     = "East US"
}

variable "vm_admin_username" {
  description = "Admin username for the VM"
}

variable "vm_admin_password" {
  description = "Admin password for the VM"
}

variable "vm_computer_name" {
  description = "Computer name for the VM"
}
variable "subscription_id" {
  description = "Azure subscription ID"
}
variable "vm_address_space" {
  description = "The address space for the Virtual Machine"
  type        = string  
}
variable "vm_address_prefixes" {
  description = "The address prefixes for the Virtual Machine"
  type        = string
}
variable "customer" {
  description = "Customer name"
  type        = string
}