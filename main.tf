#dependencies

#fetch_os_image_from_azure_shared_image_gallery
data "azurerm_shared_image" "image" {
  for_each            = var.vm_data
  name                = each.value.image_name
  gallery_name        = each.value.image_gallery_name
  resource_group_name = each.value.image_resource_group
}

#fetch_key_vault
data "azurerm_key_vault" "main" {
   name                = var.kvname
   resource_group_name = var.kvrs
}

#fetch_key_vault_secrets
data "azurerm_key_vault_secret" "vm_pwd" {
  name         = "vm-admin-pwd"
  key_vault_id = data.azurerm_key_vault.main.id
}
data "azurerm_key_vault_secret" "ad_user" {
  name         = "dc-sa-name"
  key_vault_id = data.azurerm_key_vault.main.id
}
data "azurerm_key_vault_secret" "dc-sa-password" {
  name         = "dc-sa-password"
  key_vault_id = data.azurerm_key_vault.main.id
}
data "azurerm_key_vault_secret" "storageAccountName" {
  name         = "storageAccountName"
  key_vault_id = data.azurerm_key_vault.main.id
}
data "azurerm_key_vault_secret" "storageAccountKey" {
  name         = "storageAccountKey"
  key_vault_id = data.azurerm_key_vault.main.id
}

#fetch_vnet
data "azurerm_virtual_network" "vnet" {
  for_each             = var.vm_data
  name                = each.value.vm_vnet_name
  resource_group_name = each.value.vm_vnet_rgname
}

#fetch_subnet
data "azurerm_subnet" "vnet" {
  for_each             = var.vm_data
  name                 = each.value.vm_vnet_subnet
  virtual_network_name = each.value.vm_vnet_name
  resource_group_name  = each.value.vm_vnet_rgname
}

#modules

#Resource_group_module(can_create_multiple_rgs)
module "resource_group" {
  source                  = "git::https://github.com/mcdonalds-corp-new/terraform_azurerm_resource_group.git?ref=latest"
  for_each                   = var.rg_data
  resource_group_name        = each.value.resource_group_name
  vm_resource_group_location = each.value.resource_group_location             
  tags                       = each.value.tags       
}

#availability_set
module "availability_set" {
  source                  = "git::https://github.com/mcdonalds-corp-new/terraform_azurerm_availability_set.git?ref=latest"
  for_each                      = var.availabilty_set
  availabilitysetname           = each.value.availabilitysetname
  vnet_location                 = data.azurerm_virtual_network.vnet[each.key].location
  resource_group_name           = each.value.resource_group_name
  fault_domain_count            = each.value.fault_domain_count
  update_domain_count           = each.value.update_domain_count
  tags                          = each.value.tags
  depends_on                    = [module.resource_group]
}

  module "datadisk" {
  source                  = "git::https://github.com/mcdonalds-corp-new/terraform_azurerm_disk_external.git?ref=latest"
  for_each                            = var.vm_data
  datadisk                            = each.value.datadisk
  vm_name                             = each.value.vm_name
  resource_group_name                 = each.value.rg_name
  vm_id                               = each.value.ostype != "windows" ? module.virtual_machine_linux[each.key].virtual_machine_id : module.virtual_machine_windows[each.key].virtual_machine_id 
  vnet_location                       = data.azurerm_virtual_network.vnet[each.key].location
  tags                                = var.tags
  depends_on                          = [module.resource_group]
}


module "network_interface" {
  source                  = "git::https://github.com/mcdonalds-corp-new/terraform_azurerm_network_interface.git?ref=latest"
  for_each                      = var.vm_data
  vm_name                       = each.value.vm_name
  vnet_location                 = data.azurerm_virtual_network.vnet[each.key].location
  resource_group_name           = each.value.rg_name
  enable_accelerated_networking = each.value.enable_accelerated_networking
  dns_servers                   = each.value.dns_servers
  subnet_id                     =  data.azurerm_subnet.vnet[each.key]["id"]
  private_ip_allocation_type    = each.value.private_ip_allocation_type
  private_ip_address            = each.value.private_ip_address
  ip_configuration_name         = each.value.ip_configuration_name
  tags                          = var.tags
  depends_on                    = [module.resource_group]
}

module "virtual_machine_linux" {
  source                  = "git::https://github.com/mcdonalds-corp-new/terraform_azurerm_virtual_machine_linux.git?ref=latest"
  for_each                   = {for key, val in var.vm_data: key => val if val.ostype == "linux"}
  vm_name                    = each.value.vm_name
  vnet_location              = data.azurerm_virtual_network.vnet[each.key].location
  network_interface_ids      = module.network_interface[each.key].network_interface_ids
  vm_size                    = each.value.vm_size
  zones                      = each.value.availability_zones
  availability_set_id        = each.value.availability_set_id
  storage_disk_caching       = each.value.storage_disk_caching
  storage_disk_create_option = each.value.storage_disk_create_option
  storage_disk_size          = each.value.os_storage_disk_size
  vm_admin_name              = each.value.vm_admin_name
  vm_admin_password          = data.azurerm_key_vault_secret.vm_pwd.value  
  resource_group_name        = each.value.rg_name
  tags                       = var.tags
  linux_image_id             = data.azurerm_shared_image.image[each.key]["id"]
  extension_bginfo_disks     = ""//module.datadisk_windows
  vm_tags_DomainSuffix       = each.value.domainjoin == null ? null : each.value.domainjoin.ad_DomainSuffix
  ad_user                    = each.value.domainjoin == null ? null : data.azurerm_key_vault_secret.ad_user.value 
  ad_passwd                  = each.value.domainjoin == null ? null : data.azurerm_key_vault_secret.dc-sa-password.value
  ad_zone                    = each.value.domainjoin == null ? null : each.value.domainjoin.ad_zone
  ad_ou                      = each.value.domainjoin == null ? null : each.value.domainjoin.ad_ou
  storageAccountKey          = data.azurerm_key_vault_secret.storageAccountKey.value
  storageAccountName         = data.azurerm_key_vault_secret.storageAccountName.value
  storage_container          = var.storage_container
  storage_blobname           = var.storage_blobname
  depends_on                 = [module.resource_group,module.availability_set]

}

module "virtual_machine_windows" {
  source                  = "git::https://github.com/mcdonalds-corp-new/terraform_azurerm_virtual_machine_windows.git?ref=latest"
  for_each                   = {for key, val in var.vm_data: key => val if val.ostype == "windows"}
  vm_name                    = each.value.vm_name
  vnet_location              = data.azurerm_virtual_network.vnet[each.key].location 
  network_interface_ids      = module.network_interface[each.key].network_interface_ids
  vm_size                    = each.value.vm_size
  zones                      = each.value.availability_zones
  availability_set_id        = each.value.availability_set_id
  storage_disk_caching       = each.value.storage_disk_caching
  storage_disk_create_option = each.value.storage_disk_create_option
  storage_disk_size          = each.value.os_storage_disk_size
  vm_admin_name              = each.value.vm_admin_name
  vm_admin_password          = data.azurerm_key_vault_secret.vm_pwd.value  
  resource_group_name        = each.value.rg_name
  tags                       = var.tags
  windows_image_id           = data.azurerm_shared_image.image[each.key]["id"]
  extension_bginfo_disks     = ""//module.datadisk_windows
  vm_tags_DomainSuffix       = each.value.domainjoin == null ? null : each.value.domainjoin.ad_DomainSuffix
  ad_user                    = each.value.domainjoin == null ? null : data.azurerm_key_vault_secret.ad_user.value
  ad_passwd                  = each.value.domainjoin == null ? null : data.azurerm_key_vault_secret.dc-sa-password.value
  ad_ou                      = each.value.domainjoin == null ? null : each.value.domainjoin.ad_ou
  depends_on                 = [module.resource_group,module.availability_set]
}


