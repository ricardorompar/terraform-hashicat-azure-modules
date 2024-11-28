variable "prefix" {
  description = "This prefix will be included in the name of most resources."
}

variable "location" {
  description = "The region where the virtual network is created."
  default     = "centralus"
}

variable "hcp_project_id" {
  description = "ID of the project in HCP where the cluster will be deployed."
}