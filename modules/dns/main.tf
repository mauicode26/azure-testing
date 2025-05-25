# Azure DNS module for domain management

resource "azurerm_dns_zone" "main" {
  name                = var.domain_name
  resource_group_name = var.resource_group_name
  
  tags = var.tags
}

# A records for applications
resource "azurerm_dns_a_record" "a_records" {
  for_each            = var.a_records
  name                = each.key
  zone_name           = azurerm_dns_zone.main.name
  resource_group_name = var.resource_group_name
  ttl                 = var.default_ttl
  records             = each.value.records
  
  tags = var.tags
}

# CNAME records for applications
resource "azurerm_dns_cname_record" "cname_records" {
  for_each            = var.cname_records
  name                = each.key
  zone_name           = azurerm_dns_zone.main.name
  resource_group_name = var.resource_group_name
  ttl                 = var.default_ttl
  record              = each.value.record
  
  tags = var.tags
}
