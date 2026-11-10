output "site_url" {
  description = "URL publique du site NimbusShop (via le Load Balancer)"
  value       = "http://${azurerm_public_ip.lb.ip_address}"
}
output "jumpbox_public_ip" {
  description = "IP publique de la jumpbox (seule entrée SSH)"
  value       = azurerm_public_ip.jumpbox.ip_address
}

output "web_private_ips" {
  description = "IP privées des VM web, joignables en SSH via la jumpbox"
  value       = azurerm_network_interface.web[*].private_ip_address
}