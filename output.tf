output "subnet_id" {
  description = "Subnet ID from network module"
  value       = module.network.subnet_id
}

output "subnet_ids" {
  description = "All subnet IDs"
  value       = module.network.subnet_ids
}

output "vnet_name" {
  description = "VNet name"
  value       = module.network.vnet_name
}

output "vnet_id" {
  description = "VNet ID"
  value       = module.network.vnet_id
}



