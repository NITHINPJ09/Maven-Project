variable "ASI" {
  sensitive   = true
  description = "Subscription ID of Azure"
}
variable "ACI" {
  sensitive   = true
  description = "Client ID"
}
variable "ACS" {
  sensitive   = true
  description = "Client Secret"
}
variable "ATI" {
  sensitive   = true
  description = "Tenant ID"
}
variable "ATI" {
  sensitive   = true
  description = "Tenant ID"
}
variable "resource_group_name" {
  description = "Name of the Resource Group"
}
variable "resource_group_location" {
  description = "location of the Resource Group"
}
variable "virtual_network_name" {
  description = "Name of the Virtual Network"
}
variable "virtual_network_address_space" {
  description = "Address Space of Virtual Network"
}
variable "subnet_name" {
  description = "Name of the Subnet"
}
variable "subnet_address_prefixes" {
  description = "Address Prefixes of Subnet"
}
variable "network_interface_name" {
  description = "Name of the Network Interface"
}
variable "virtual_machine_name" {
  description = "Name of the Virtual Machine"
}
variable "username" {
  description = "Name of the User"
}
variable "public_ip_name" {
  description = "Name of the Public IP"
}
variable "storage_account_name" {
  description = "Name of the Storage Account"
}
variable "storage_container_name" {
  description = "Name of the Storage Container"
}
variable "storage_blob_name" {
  description = "Name of the Storage Blob"
}
variable "local_file_name" {
  description = "Name of the Local File"
}
