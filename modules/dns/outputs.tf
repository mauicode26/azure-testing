output "dns_zone_id" {
  description = "DNS zone ID"
  value       = azurerm_dns_zone.main.id
}

output "dns_zone_name" {
  description = "DNS zone name"
  value       = azurerm_dns_zone.main.name
}

output "dns_zone_name_servers" {
  description = "Name servers for the DNS zone"
  value       = azurerm_dns_zone.main.name_servers
}

output "dns_zone_resource_group_name" {
  description = "Resource group name for the DNS zone"
  value       = azurerm_dns_zone.main.resource_group_name
}

output "a_record_fqdns" {
  description = "FQDNs of created A records"
  value       = { for k, v in azurerm_dns_a_record.a_records : k => v.fqdn }
}

output "cname_record_fqdns" {
  description = "FQDNs of created CNAME records"
  value       = { for k, v in azurerm_dns_cname_record.cname_records : k => v.fqdn }
}
