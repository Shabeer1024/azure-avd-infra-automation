output "workspace_id" {
  value = azurerm_log_analytics_workspace.avd.id
}

output "workspace_name" {
  value = azurerm_log_analytics_workspace.avd.name
}

output "action_group_id" {
  value = azurerm_monitor_action_group.avd_alerts.id
}



