output "public_ip" {
  value = azurerm_public_ip.app_public_ip.ip_address
}
