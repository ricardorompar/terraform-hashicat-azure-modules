output "resource_group_name" {
  value = azurerm_resource_group.myresourcegroup.name
}

output "vm_subnet_id" {
  value = azurerm_subnet.vm_subnet.id
}

output "appgw_subnet_id" {
  value = azurerm_subnet.appgw_subnet.id
}

output "security_group_id" {
  value = azurerm_network_security_group.catapp-mgmt-sg.id
}