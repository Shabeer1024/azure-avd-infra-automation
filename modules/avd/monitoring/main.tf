# ── Log Analytics Workspace ──────────────────────────────────────
resource "azurerm_log_analytics_workspace" "avd" {
  name                = var.workspace_name
  resource_group_name = var.resource_group_name
  location            = var.location
  sku                 = "PerGB2018"
  retention_in_days   = 30
  tags                = { role = "log-analytics" }
}

# ── AVD Host Pool Diagnostics ────────────────────────────────────
resource "azurerm_monitor_diagnostic_setting" "hostpool" {
  name                       = "avd-hostpool-diag"
  target_resource_id         = var.host_pool_id
  log_analytics_workspace_id = azurerm_log_analytics_workspace.avd.id

  enabled_log { category = "Checkpoint" }
  enabled_log { category = "Error" }
  enabled_log { category = "Management" }
  enabled_log { category = "Connection" }
  enabled_log { category = "HostRegistration" }
  enabled_log { category = "AgentHealthStatus" }
}

# ── Session Host VM Diagnostics ──────────────────────────────────
resource "azurerm_monitor_diagnostic_setting" "session_hosts" {
  count                      = length(var.session_host_ids)
  name                       = "avd-sh-${count.index}-diag"
  target_resource_id         = var.session_host_ids[count.index]
  log_analytics_workspace_id = azurerm_log_analytics_workspace.avd.id

  metric {
    category = "AllMetrics"
    enabled  = true
  }
}

# ── DC Diagnostics ───────────────────────────────────────────────
resource "azurerm_monitor_diagnostic_setting" "dc" {
  name                       = "dc-diag"
  target_resource_id         = var.dc_vm_id
  log_analytics_workspace_id = azurerm_log_analytics_workspace.avd.id

  metric {
    category = "AllMetrics"
    enabled  = true
  }
}

# ── Action Group — Email Alerts ──────────────────────────────────
resource "azurerm_monitor_action_group" "avd_alerts" {
  name                = "avd-alert-group"
  resource_group_name = var.resource_group_name
  short_name          = "avdalerts"

  email_receiver {
    name          = "avd-admin"
    email_address = var.alert_email
  }

  tags = { role = "alert-action-group" }
}

# ── Alert: High CPU on Session Hosts ─────────────────────────────
resource "azurerm_monitor_metric_alert" "high_cpu" {
  count               = length(var.session_host_ids)
  name                = "avd-sh-${count.index}-high-cpu"
  resource_group_name = var.resource_group_name
  scopes              = [var.session_host_ids[count.index]]
  description         = "Alert when CPU exceeds 80%"
  severity            = 2
  frequency           = "PT5M"
  window_size         = "PT15M"

  criteria {
    metric_namespace = "Microsoft.Compute/virtualMachines"
    metric_name      = "Percentage CPU"
    aggregation      = "Average"
    operator         = "GreaterThan"
    threshold        = 80
  }

  action {
    action_group_id = azurerm_monitor_action_group.avd_alerts.id
  }

  tags = { role = "cpu-alert" }
}

# ── Alert: Session Host Unavailable ──────────────────────────────
resource "azurerm_monitor_metric_alert" "vm_unavailable" {
  count               = length(var.session_host_ids)
  name                = "avd-sh-${count.index}-unavailable"
  resource_group_name = var.resource_group_name
  scopes              = [var.session_host_ids[count.index]]
  description         = "Alert when session host is unavailable"
  severity            = 1
  frequency           = "PT1M"
  window_size         = "PT5M"

  criteria {
    metric_namespace = "Microsoft.Compute/virtualMachines"
    metric_name      = "VmAvailabilityMetric"
    aggregation      = "Average"
    operator         = "LessThan"
    threshold        = 1
  }

  action {
    action_group_id = azurerm_monitor_action_group.avd_alerts.id
  }

  tags = { role = "availability-alert" }
}

# ── Alert: High Memory on Session Hosts ──────────────────────────
resource "azurerm_monitor_metric_alert" "high_memory" {
  count               = length(var.session_host_ids)
  name                = "avd-sh-${count.index}-high-memory"
  resource_group_name = var.resource_group_name
  scopes              = [var.session_host_ids[count.index]]
  description         = "Alert when available memory drops below 1GB"
  severity            = 2
  frequency           = "PT5M"
  window_size         = "PT15M"

  criteria {
    metric_namespace = "Microsoft.Compute/virtualMachines"
    metric_name      = "Available Memory Bytes"
    aggregation      = "Average"
    operator         = "LessThan"
    threshold        = 1073741824
  }

  action {
    action_group_id = azurerm_monitor_action_group.avd_alerts.id
  }

}



