variable "ASI" { 
  type        = string
  sensitive   = true
  description = "Subscription ID of Azure"
}
variable "ACI" {
  type        = string
  sensitive   = true
  description = "Client ID"
}
variable "ACS" {
  type        = string
  sensitive   = true
  description = "Client Secret"
}
variable "ATI" {
  type        = string
  sensitive   = true
  description = "Tenant ID"
}
