provider "azurerm" {
  features {
    resource_group {
      prevent_deletion_if_contains_resources = false
    }
  }
}

provider "hcp" {
    project_id = var.hcp_project_id
}

module "networking" {
  source        = "./networking"
  prefix        = var.prefix
  location      = var.location
}

module "compute" {
  source                = "./compute"
  prefix                = var.prefix
  location              = var.location
  resource_group_name   = module.networking.resource_group_name
  vm_subnet_id          = module.networking.vm_subnet_id
  security_group_id     = module.networking.security_group_id
  vault_addr            = module.vault.vault_addr
  vault_app_token       = module.vault-config.vault_app_token
}

module "appgateway" {
  source                = "./app-gateway"
  prefix                = var.prefix
  location              = var.location
  resource_group_name   = module.networking.resource_group_name
  appgw_subnet_id       = module.networking.appgw_subnet_id
  vm_ips                = module.compute.vm_ips 
}

module "vault" {
  source = "./vault-cluster"
}

module "vault-config" {
  source        = "./vault-config"
  vault_addr    = module.vault.vault_addr
  vault_token   = module.vault.vault_token
}