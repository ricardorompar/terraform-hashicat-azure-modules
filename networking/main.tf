terraform {
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "4.9.0"
    }
  }
}

resource "azurerm_resource_group" "myresourcegroup" {
  name     = "${var.prefix}-demo"
  location = var.location

  tags = {
    environment = "Production"
  }
}

resource "azurerm_virtual_network" "vnet" {
  name                = "${var.prefix}-vnet"
  location            = azurerm_resource_group.myresourcegroup.location
  address_space       = [var.address_space]
  resource_group_name = azurerm_resource_group.myresourcegroup.name
}

#######################
#      VM Subnet      #
#######################
resource "azurerm_subnet" "vm_subnet" {
  name                 = "${var.prefix}-subnet"
  virtual_network_name = azurerm_virtual_network.vnet.name
  resource_group_name  = azurerm_resource_group.myresourcegroup.name
  address_prefixes     = [var.vm_subnet_prefix]
}

#######################
#     AppGW Subnet    #
#######################
resource "azurerm_subnet" "appgw_subnet" {
  name                 = "${var.prefix}-appgw-subnet"
  virtual_network_name = azurerm_virtual_network.vnet.name
  resource_group_name  = azurerm_resource_group.myresourcegroup.name
  address_prefixes     = [var.appgw_subnet_prefix]
}

#######################
#   Security Groups   #
#######################
# SG1: will be used to allow communication between the two Subnets:

resource "azurerm_network_security_group" "vm_subnet_nsg" {
  name                = "${var.prefix}-sg"
  location            = var.location
  resource_group_name = azurerm_resource_group.myresourcegroup.name

  security_rule {
    name                       = "AllowAppGwToVM"
    priority                   = 100
    direction                  = "Inbound"
    access                     = "Allow"
    protocol                   = "Tcp"
    source_port_range          = "*"
    destination_port_range     = "*"
    source_address_prefix      = var.appgw_subnet_prefix
    destination_address_prefix = var.vm_subnet_prefix
  }
}

# SG2: allow SSH to VM subnet:
resource "azurerm_network_security_group" "catapp-mgmt-sg" {
  name                = "${var.prefix}-mgmt-sg"
  location            = var.location
  resource_group_name = azurerm_resource_group.myresourcegroup.name

  security_rule {
    name                       = "SSH"
    priority                   = 101
    direction                  = "Inbound"
    access                     = "Allow"
    protocol                   = "Tcp"
    source_port_range          = "*"
    destination_port_range     = "22"
    source_address_prefix      = "*"
    destination_address_prefix = "*"
  }

  security_rule {
    name                       = "allow-vault-ingress"
    priority                   = 100
    direction                  = "Inbound"
    access                     = "Allow"
    protocol                   = "Tcp"
    source_port_range          = "*"
    destination_port_range     = "8200"
    source_address_prefix      = "*"
    destination_address_prefix = "*"
  }
}

