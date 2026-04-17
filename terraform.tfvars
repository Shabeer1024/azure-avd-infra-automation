resource_group_name = "AVD-image-Lab"
location            = "centralus"
vnet_name           = "Vnet01"
vnet_address_prefix = "10.0.0.0/16"
vnet_subnet_count   = 2

storage_account_name = "avdlabscripts001"

gallery_name          = "avdLabGallery"
image_definition_name = "avd-win11-multisession"

host_pool_name     = "avd-lab-hostpool" 
app_group_name     = "avd-lab-appgroup"
token_expiry_hours = 48

build_vm_name   = "avd-build-vm"
build_vm_size   = "Standard_D2s_v3"
build_image_sku = "win11-24h2-avd"
admin_username  = "avdadmin"
admin_password  = "D0n0t$hareit"

subscription_id    = "1yyyyyyyy-yyyy-yyyy-yyyy-yyyyyyyyyyyy"
image_version      = "1.0.0"
session_host_count = 2


enable_session_hosts = true # ← disables hosts during build

dc_vm_name    = "avd-dc-01"
dc_vm_size    = "Standard_D2s_v3"
domain_name   = "avdlab.local"
dc_private_ip = "10.0.1.4"
dns_servers = ["10.0.1.4"]  # ← DC static IP

fslogix_share_name  = "profiles"
fslogix_share_quota = 100
 
alert_email    = "today.devops@outlook.com"

workspace_name               = "avd-lab-workspace"
log_analytics_workspace_name = "avd-log-analytics" 

scaling_plan_name   = "avd-scaling-plan"
time_zone           = "UTC"
peak_start_time     = "09:00"
peak_end_time       = "18:00"
ramp_up_start_time  = "06:00"
off_peak_start_time = "20:00"