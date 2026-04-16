resource "azurerm_virtual_desktop_scaling_plan" "avd" {
  name                = var.scaling_plan_name
  resource_group_name = var.resource_group_name
  location            = var.location
  friendly_name       = "AVD Auto Scaling Plan"
  description         = "Automated scaling for AVD session hosts"
  time_zone           = var.time_zone

  # ── Weekday Schedule ──────────────────────────────────────────
  schedule {
    name                                 = "Weekdays"
    days_of_week                         = ["Monday", "Tuesday", "Wednesday", "Thursday", "Friday"]

    # Ramp Up — start VMs before peak
    ramp_up_start_time                   = var.ramp_up_start_time
    ramp_up_load_balancing_algorithm     = "BreadthFirst"
    ramp_up_minimum_hosts_percent        = var.minimum_hosts_percent
    ramp_up_capacity_threshold_percent   = var.capacity_threshold_percent

    # Peak — all VMs running
    peak_start_time                      = var.peak_start_time
    peak_load_balancing_algorithm        = "BreadthFirst"

    # Ramp Down — drain sessions
    ramp_down_start_time                 = var.peak_end_time
    ramp_down_load_balancing_algorithm   = "DepthFirst"
    ramp_down_minimum_hosts_percent      = var.minimum_hosts_percent
    ramp_down_capacity_threshold_percent = var.capacity_threshold_percent
    ramp_down_force_logoff_users         = false
    ramp_down_wait_time_minutes          = 30
    ramp_down_notification_message       = "Session will end in 30 minutes. Please save your work."
    ramp_down_stop_hosts_when            = "ZeroActiveSessions"

    # Off Peak — minimum hosts
    off_peak_start_time                  = var.off_peak_start_time
    off_peak_load_balancing_algorithm    = "DepthFirst"
  }

  # ── Weekend Schedule ──────────────────────────────────────────
  schedule {
    name                                 = "Weekend"
    days_of_week                         = ["Saturday", "Sunday"]

    # Minimal ramp up on weekends
    ramp_up_start_time                   = "08:00"
    ramp_up_load_balancing_algorithm     = "DepthFirst"
    ramp_up_minimum_hosts_percent        = 10
    ramp_up_capacity_threshold_percent   = 90

    peak_start_time                      = "10:00"
    peak_load_balancing_algorithm        = "DepthFirst"

    ramp_down_start_time                 = "16:00"
    ramp_down_load_balancing_algorithm   = "DepthFirst"
    ramp_down_minimum_hosts_percent      = 10
    ramp_down_capacity_threshold_percent = 90
    ramp_down_force_logoff_users         = false
    ramp_down_wait_time_minutes          = 15
    ramp_down_notification_message       = "Session will end in 15 minutes. Please save your work."
    ramp_down_stop_hosts_when            = "ZeroActiveSessions"

    off_peak_start_time                  = "18:00"
    off_peak_load_balancing_algorithm    = "DepthFirst"
  }

  # ── Associate with Host Pool ──────────────────────────────────
  host_pool {
    hostpool_id          = var.host_pool_id
    scaling_plan_enabled = true
  }

  tags = { role = "scaling-plan" }
}



