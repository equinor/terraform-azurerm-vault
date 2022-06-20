variable "application" {
  description = "The application to create the resources for."
  type        = string
}

variable "environment" {
  description = "The environment to create the resources for."
  type        = string
}

variable "key_vault_name" {
  description = "A custom name for the Key Vault."
  type        = string
  default     = null
}

variable "location" {
  description = "The supported Azure location where the resources exist."
  type        = string
}

variable "resource_group_name" {
  description = "The name of the resource group in which to create the resources."
  type        = string
}

variable "tags" {
  description = "A mapping of tags to assign to the resources."
  type        = map(string)
  default     = {}
}

variable "purge_protection_enabled" {
  description = "Is purge protection enabled for this key vault?"
  type        = bool
  default     = false
}

variable "firewall_ip_rules" {
  description = "A list of IP addresses or CIDR blocks that should be able to access the Key Vault."
  type        = list(string)
  default     = []
}

variable "firewall_subnet_rules" {
  description = "A list of IDs of the subnets that should be able to access the Key Vault."
  type        = list(string)
  default     = []
}

variable "log_analytics_workspace_id" {
  description = "The ID of the Log Analytics Workspace to send diagnostics to."
  type        = string
}
