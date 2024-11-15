variable "prefix" {
  description = "This prefix will be included in the name of most resources."
}

variable "location" {
  description = "The region where the virtual network is created."
  default     = "centralus"
}

variable "address_space" {
  description = "The address space that is used by the virtual network. You can supply more than one address space. Changing this forces a new resource to be created."
  default     = "10.0.0.0/16"
}

variable "vm_subnet_prefix" {
  description = "The address prefix to use for the VMs subnet."
  default     = "10.0.10.0/24"
}

variable "appgw_subnet_prefix" {
  description = "The address prefix to use for the AppGWs subnet."
  default     = "10.0.11.0/24"
}