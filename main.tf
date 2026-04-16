module "resourcegroup" {
  source              = "./modules/resourcegroup"
  resource_group_name = var.resource_group_name
  location            = var.location
}

module "network" {
  source              = "./modules/network/vnet"
  resource_group_name = var.resource_group_name
  location            = var.location
  vnet_name           = var.vnet_name
  vnet_address_prefix = var.vnet_address_prefix
  vnet_subnet_count   = var.vnet_subnet_count
  dns_servers         = var.dns_servers 
  depends_on          = [module.resourcegroup]
}

module "hostpool" {
  source              = "./modules/avd/hostpool"
  vnet_name           = var.vnet_name
  resource_group_name = var.resource_group_name
  app_group_name      = var.app_group_name
  location            = var.location
  host_pool_name      = var.host_pool_name
    workspace_name      = var.workspace_name

  token_expiry_hours  = var.token_expiry_hours
  depends_on          = [module.resourcegroup]
}

module "image_gallery" {
  source                = "./modules/avd/image-gallery"
  resource_group_name   = var.resource_group_name
  location              = var.location
  gallery_name          = var.gallery_name
  image_definition_name = var.image_definition_name
  depends_on            = [module.resourcegroup]
}

module "build_vm" {
  source              = "./modules/avd/build-vm"
  resource_group_name = var.resource_group_name
  location            = var.location
  subnet_id           = module.network.subnet_id
  vm_name             = var.build_vm_name
  vm_size             = var.build_vm_size
  admin_username      = var.admin_username
  admin_password      = var.admin_password
  image_sku           = var.build_image_sku
  depends_on          = [module.network]
}

module "storage" {
  source               = "./modules/avd/storage"
  resource_group_name  = var.resource_group_name
  location             = var.location
  storage_account_name = var.storage_account_name
  container_name       = "scripts"
  depends_on           = [module.resourcegroup]
}

module "app_install" {
  source               = "./modules/avd/app-install"
  resource_group_name  = var.resource_group_name
  location             = var.location
  vm_name              = module.build_vm.build_vm_name
  storage_account_name = var.storage_account_name
  storage_account_key  = module.storage.storage_account_key
  container_name       = "scripts"
  depends_on           = [module.build_vm, module.storage]
}

module "sysprep" {
  source              = "./modules/avd/sysprep"
  resource_group_name = var.resource_group_name
  location            = var.location
  vm_name             = module.build_vm.build_vm_name
  depends_on          = [module.app_install]
}

module "image_capture" {
  source                = "./modules/avd/image-capture"
  resource_group_name   = var.resource_group_name
  location              = var.location
  vm_name               = module.build_vm.build_vm_name
  gallery_name          = var.gallery_name
  image_definition_name = var.image_definition_name
  subscription_id       = var.subscription_id
  image_version         = var.image_version
  depends_on            = [module.sysprep]
}

# module "session_hosts" {
#   source                = "./modules/avd/session-hosts"
#   resource_group_name   = var.resource_group_name
#   location              = var.location
#   subnet_id             = module.network.subnet_id
#   admin_username        = var.admin_username
#   admin_password        = var.admin_password
#   host_pool_name        = var.host_pool_name
#   registration_token    = module.hostpool.registration_token
#   vm_name_prefix        = "avd-sh"
#   vm_size               = var.build_vm_size
#   vm_count              = var.session_host_count
#   subscription_id       = var.subscription_id
#   gallery_name          = var.gallery_name
#   image_definition_name = var.image_definition_name
#   image_version         = var.image_version
#   depends_on            = [module.hostpool]
# }

module "session_hosts" {
  source                = "./modules/avd/session-hosts"
  enable_session_hosts  = var.enable_session_hosts # ← add this line
  resource_group_name   = var.resource_group_name
  location              = var.location
  subnet_id             = module.network.subnet_id
  admin_username        = var.admin_username
  admin_password        = var.admin_password
  host_pool_name        = var.host_pool_name
  registration_token    = module.hostpool.registration_token
  vm_name_prefix        = "avd-sh"
  vm_size               = var.build_vm_size
  vm_count              = var.session_host_count
  subscription_id       = var.subscription_id
  gallery_name          = var.gallery_name
  image_definition_name = var.image_definition_name
  image_version         = var.image_version
  depends_on            = [module.hostpool]
}

# ── Domain Controller ───────────────────

module "domain_controller" {
  source              = "./modules/avd/domain-controller"
  resource_group_name = var.resource_group_name
  location            = var.location
  subnet_id           = module.network.dc_subnet_id
  admin_username      = var.admin_username
  admin_password      = var.admin_password
  vm_name             = var.dc_vm_name
  vm_size             = var.dc_vm_size
  domain_name         = var.domain_name
  private_ip_address  = var.dc_private_ip
  depends_on          = [module.network]
}

#  VNet DNS to point to DC after DC is ready
# module "network_dns_update" {
#   source              = "./modules/network/vnet"
#   resource_group_name = var.resource_group_name
#   location            = var.location
#   vnet_name           = var.vnet_name
#   vnet_address_prefix = var.vnet_address_prefix
#   avd_subnet_prefix   = var.avd_subnet_prefix
#   dc_subnet_prefix    = var.dc_subnet_prefix
#   dns_servers         = [module.domain_controller.dc_private_ip]
#   depends_on          = [module.domain_controller]
# }

module "domain_join" {
  source              = "./modules/avd/domain-join"
  resource_group_name = var.resource_group_name
  location            = var.location
  domain_name         = var.domain_name
  admin_username      = var.admin_username
  admin_password      = var.admin_password
  vm_ids              = module.session_hosts.session_host_ids
  vm_names            = module.session_hosts.session_host_names
  depends_on          = [module.domain_controller, module.session_hosts]
}

module "fslogix" {
  source               = "./modules/fslogix"
  resource_group_name  = var.resource_group_name
  location             = var.location
  storage_account_name = var.storage_account_name
  storage_account_id   = module.storage.storage_account_id
  share_name           = var.fslogix_share_name
  share_quota_gb       = var.fslogix_share_quota
  session_host_ids     = module.session_hosts.session_host_ids
  domain_name          = var.domain_name
  admin_username       = var.admin_username
  admin_password       = var.admin_password
  depends_on           = [module.session_hosts, module.domain_join]
}

module "monitoring" {
  source              = "./modules/avd/monitoring"
  resource_group_name = var.resource_group_name
  location            = var.location
  workspace_name      = var.workspace_name
  host_pool_id        = module.hostpool.host_pool_id
  host_pool_name      = var.host_pool_name
  session_host_ids    = module.session_hosts.session_host_ids
  alert_email         = var.alert_email
  dc_vm_id            = module.domain_controller.dc_vm_id
  depends_on          = [module.hostpool, module.session_hosts]
}

module "scaling_plan" {
  source              = "./modules/avd/scaling-plan"
  resource_group_name = var.resource_group_name
  location            = var.location
  host_pool_id        = module.hostpool.host_pool_id
  host_pool_name      = var.host_pool_name
  scaling_plan_name   = var.scaling_plan_name
  time_zone           = var.time_zone
  peak_start_time     = var.peak_start_time
  peak_end_time       = var.peak_end_time
  ramp_up_start_time  = var.ramp_up_start_time
  off_peak_start_time = var.off_peak_start_time
  depends_on          = [module.hostpool]
}



