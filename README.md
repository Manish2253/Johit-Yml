# Subscription handled by this repo

```yml
PROD:
 MCD-CORP-PROD-01   
 345395af-dab3-4547-9ebb-bbb00ceffcac
 NONPROD:
 MCD-CORP-NONPROD-01
 2b8dbbd2-999e-49f3-bb5e-f307d7658ac6
 SANDBOX:
 McDonalds Corp - Sandbox (Infosys)
 1ff52360-ccb7-42c0-8a63-e4424d746eac
```

# Resource Modules template

## Resource Group Module
```terraform
# (optional) create multiple resource groups

rg_data = {
             "0" = {
                   # location (Required) The Azure Region where the Resource Group should exist. 
                    resource_group_location   = []
                    # name (Required) The Name which should be used for this Resource Group.
                    resource_group_name       = []
                    # tags (required) A mapping of tags which should be assigned to the Resource Group.
                        tags                  = []
                 },
        }
```

## availabilty_set  Module
```terraform
 #(optional) create multiple availability set

availabilty_set = {
              "0" = {
               #(required)availability set name
                        availabilitysetname = []
               #(required) resource group name
                        resource_group_name = []
               #(required)
                        fault_domain_count = []
               #(required)
                        update_domain_count = []
                #(required)
                        tags = []
            },
}

Note: 'availability_set' or 'availability zone' use only one resources, 'availability set' is using, set 'availability zones' as null in Virtual Machine and 'zones' as null in datadisk
```          


## multiple virtual machine (window/linux) Module
```terraform
vm_data = {
            "0" = {
                    rg_name                       = []    #  (Required) Specifies the name of the rg name for vm.
                    ostype                        = []    #(Required) whether it is (windows/linux)
                    nic_name                      = []    # (Required) Network Interface should be associated with the vm
                    dns_servers                   = null  #(optional) A list of IP Addresses defining the DNS Servers which should be used for this Network Interface.
                    private_ip_allocation_type    = []    #  (Required)  private ip address allocation type dynamic
                    private_ip_address            = []    # (optional)  static private ip for vm
                         Note : 'private_ip_address' can set be specified when 'private_ip_allocation_type' is set as 'static'
                    ip_configuration_name         = []  # (required) name of the configration
                    vm_vnet_subnet                = []    # (Required) subnet name of vm
                    vm_vnet_name                  = [] #  (Required) Specifies the name of the vnet name for vm.
                    vm_vnet_rgname                = [] #  (Required) Specifies the name of the vnet rg name for vm.
                    availability_set_id           = null  #  (Optional) The ID of the Availability Set in which the Virtual Machine should exis"/subscriptions/1ff52360-ccb7-42c0-8a63-e4424d746eac/resourceGroups/<give-rg-name-here>/providers/Microsoft.Compute/availabilitySets/<give_as_name_here>"t. "/subscriptions/1ff52360-ccb7-42c0-8a63-e4424d746eac/resourceGroups/<give-rg-name-here>/providers/Microsoft.Compute/availabilitySets/<give_as_name_here>"                   
                    vm_name                       = []    # (Required) Specifies the name of the Virtual Machine.
                    availability_zones            = []    # (optional) Specifies the name of the availability zone
                    vm_size                       = []    # (Required) Specifies the size of the Virtual Machine.
                    disk_type                     = []    # (required) Specifies the type of disk to create. 
                    storage_disk_create_option    = []    #  (Required) Specifies how the OS Disk should be created. 
                    storage_disk_caching          = []    #(required) Specifies the caching requirements for the OS Disk. 
                    os_storage_disk_size          = []    # (Optional) Specifies the size of the OS Disk in gigabytes.
                    vm_admin_name                 = []    #(Required) Specifies the name of the local administrator account.
                    enable_accelerated_networking = []    # (required) enable accelerated networking whether it is true/false
                    image_name                    = []    #(Required) Specifies the image  used to create the virtual machine.
                    image_gallery_name            = []    #(Required) Specifies the  image gallery name used to create the virtual machine.
                    image_resource_group          = []    #(Required) Specifies the image  resource group 
                    storage_disk_caching          = []    #(Required) Specifies the caching requirements for the OS Disk. 
                    
                    #(optional) for domain join
                    domanjoin = {
                                   ad_ou                         = null  # (optional) eg:  "corp.pri/Global Vendors/Infosys/INFY-Computers"
                                   ad_zone                       = []  # (required) if a_ ou is given zone is required
                                   ad_DomainSuffix               = []  # (required) is ad ou is given tis variable is required
                               }
                               
                               
                    # (required) create multiple datadisk       
                    datadisk = {
                                 "0" = {
                                         external_disk_name               = [] #  (Required) The name of the Data Disk.
                                         external_data_disk_create_option = [] #(Required) Specifies how the data disk should be created. 
                                         external_data_disk_type          = [] # (required) Specifies the type of disk to create. 
                                         external_data_disk_size          = [] # (required) Specifies the size of the data disk in gigabytes.
                                         external_data_tier               = [] #  (optional) 
                                               Note: `tier` can only be specified when `storage_account_type` is set to `Premium_LRS` or `Premium_ZRS`
                                         zones                            = [] # (optional) Specifies the zones (create disk in zones)
                                               Note: `zones` can only be specified when `availability_zones` is set in virtual machine
                                         lun                              = [] #(Required) Specifies the logical unit number of the data disk. 
                                         external_data_disk_caching       = [] # (Required) Specifies the caching requirements data disk
                                 },    
                                }
          }
      }   
      
```

## Required variables
```terraform
kvrs                                = [] #  (Required) Specifies the name of the rg name for keyvault.
kvname                              = [] #  (Required) Specifies the name of the keyvault.
storage_container                   = [] #  (Required) Specifies the name of the storage container
storage_blobname                    = [] #  (Required) Specifies the name of the storage blob name
subscription_id                     = [] # (required) specifies the subscription id

Tags = null


 SANDBOX:
 kvrs                                = "RG-2W-IMAGE-FACTORY"
kvname                              = "KV-2W-ImgFactory-Sandbox"

PROD:
kvrs                     = "RG-2W-IMAGE-PROD"
kvname                   = "KV-2W-ImgFactory-Prod"

NONPROD:
kvrs                                = "RG-2W-IMAGE-NON-PROD"
kvname                              = "KV-2W-ImgFactory-NonProd"

```

## example-usage 

 ```terraform
 
  rg_data = {
             "0" = {
                    resource_group_location   = "eastus"
                    resource_group_name       = "integration-test"
                        tags                  = {
                                                          vm_tags_ApplicationID    = "APP0001760"
                                                          vm_tags_GBL             = "195500792644"
                                                          vm_tags_Market          = "CORP"
                                                          vm_tags_method          = "GithubPipeline"
                                                          vm_tags_Owner           = "Eliot.Sherwin@us.mcd.com"
                                                          vm_tags_PatchingGroup   = "USA-DEV-UAT-1"
                                                      }
                 }
        }


availabilty_set = {
            "0" = {
                        availabilitysetname = "avset"
                        resource_group_name = "integration-test"
                        fault_domain_count = "1"
                        update_domain_count = "1"
                        tags = {
                                  vm_tags_ApplicationID    = "APP0001760"
                                  vm_tags_GBL             = "195500792644"
                                  vm_tags_Market          = "CORP"
                                  vm_tags_method          = "GithubPipeline"
                                  vm_tags_Owner           = "Eliot.Sherwin@us.mcd.com"
                                  vm_tags_PatchingGroup   = "USA-DEV-UAT-1"
                              }
            },
}



vm_data = {
            "0" = {
                    rg_name                       = "integration-test"
                    ostype                        = "linux"
                    nic_name                      = "mcdus-test-vm-nic"
                    dns_servers                   = null # ["10.0.0.4", "10.0.0.5"]
                    location                      = "eastasia"
                    ip_configuration_name         = "internal"
                    vm_vnet_subnet                = "sn-us-east-sb-main"
                    vm_vnet_name                  = "vnet-us-east-sb-main"
                    vm_vnet_rgname                = "rg-us-east-sb"
                    private_ip_allocation_type    = "Dynamic"
                    private_ip_address            = "[152.10.25.0]"
                    availability_set_id           = "/subscriptions/1ff52360-ccb7-42c0-8a63-e4424d746eac/resourceGroups/integration-test/providers/Microsoft.Compute/availabilitySets/avset"
                    vm_name                       = "integration-01"
                    availability_zones            = [1]
                    vm_size                       = "Standard_DS1_v2"
                    disk_type                     = "Standard_LRS"
                    storage_disk_create_option    = "FromImage"
                    storage_disk_caching          = "ReadWrite"
                    os_storage_disk_size          = 127
                    vm_admin_name                 = "mcdus-test-vm"
                    enable_accelerated_networking = "false"
                    image_name                    = "RHEL-7.8"
                    image_gallery_name            = "sigLinux"
                    image_resource_group          = "rg-aib-devops-us-east-linux-sig"
                    storage_disk_caching          = "ReadWrite"
                    domainjoin = {
                          ad_ou                         = null  #"corp.pri/Global Vendors/Infosys/INFY-Computers"
                          ad_zone                       = "Infosys"
                          ad_DomainSuffix               = "corp.pri"
                    }
                    datadisk = {
                                 "0" = {
                                         external_disk_name               = "az-tf-disk"
                                         external_data_disk_create_option = "Empty"
                                         external_data_disk_type          = "Standard_LRS"
                                         external_data_disk_size          = "10"
                                         external_data_tier               = "P10"
                                         zones                            = [1]
                                         lun                              = "10"
                                         external_data_disk_caching       = "ReadWrite"
                                 },
                                 "1" = {
                                         external_disk_name               = "az-tf-disk1"
                                         external_data_disk_create_option = "Empty"
                                         external_data_disk_type          = "Standard_LRS"
                                         external_data_disk_size          = "10"
                                         external_data_tier               = "P10"
                                         zones                            = [1]
                                         lun                              = "10"
                                         external_data_disk_caching       = "ReadWrite"
                                },
                            }
           },
           
       "1" = {
                    rg_name                       = "integration-test"
                    ostype                        = "windows"
                    nic_name                      = "integration-02-nic"
                    dns_servers                   = null # ["10.0.0.4", "10.0.0.5"]
                    location                      = "eastasia"
                    ip_configuration_name         = "internal"
                    vm_vnet_subnet                = "sn-us-east-sb-main"
                    vm_vnet_name                  = "vnet-us-east-sb-main"
                    vm_vnet_rgname                = "rg-us-east-sb"
                    private_ip_allocation_type    = "Dynamic"
                    private_ip_address            = "[152.10.25.0]"
                    availability_set_id           = null  # "/subscriptions/1ff52360-ccb7-42c0-8a63-e4424d746eac/resourceGroups/<give-rg-name-here>/providers/Microsoft.Compute/availabilitySets/<give_as_name_here>"
                    vm_name                       = "integration-02"
                    availability_zones            = [2]
                    vm_size                       = "Standard_DS1_v2"
                    disk_type                     = "Standard_LRS"
                    storage_disk_create_option    = "FromImage"
                    storage_disk_caching          = "ReadWrite"
                    os_storage_disk_size          = 127
                    vm_admin_name                 = "integration-02"
                    enable_accelerated_networking = "false"
                    image_name                    = "RHEL-7.8"
                    image_gallery_name            = "sigLinux"
                    image_resource_group          = "rg-aib-devops-us-east-linux-sig"
                    storage_disk_caching          = "ReadWrite"
                    domainjoin = {
                          ad_ou                         = null  #"corp.pri/Global Vendors/Infosys/INFY-Computers"
                          ad_zone                       = "Infosys"
                          ad_DomainSuffix               = "corp.pri"
                    }
                    datadisk = {
                                 "0" = {
                                         external_disk_name               = "integration-02-disk"
                                         external_data_disk_create_option = "Empty"
                                         external_data_disk_type          = "Standard_LRS"
                                         external_data_disk_size          = "10"
                                         external_data_tier               = "P10"
                                         zones                            = [2]
                                         lun                              = "10"
                                         external_data_disk_caching       = "ReadWrite"
                                 },
                                 "1" = {
                                         external_disk_name               = "integration-02-disk1"
                                         external_data_disk_create_option = "Empty"
                                         external_data_disk_type          = "Standard_LRS"
                                         external_data_disk_size          = "10"
                                         external_data_tier               = "P10"
                                         zones                            = [2]
                                         lun                              = "10"
                                         external_data_disk_caching       = "ReadWrite"
                                },
                            }
           },

      }
kvrs                                = "RG-2W-IMAGE-FACTORY"
kvname                              = "KV-2W-ImgFactory-Sandbox"
storage_container       = "centrify"
storage_blobname        = "Centrify-Infrastructure-Services-18.11-agents-DM.zip"
subscription_id         = "2b8dbbd2-999e-49f3-bb5e-f307d7658ac6"

tags = {
          vm_tags_ApplicationID    = "APP0001760"
          vm_tags_GBL             = "195500792644"
          vm_tags_Market          = "CORP"
          vm_tags_method          = "GithubPipeline"
          vm_tags_Owner           = "Eliot.Sherwin@us.mcd.com"
          vm_tags_PatchingGroup   = "USA-DEV-UAT-1"
      }
```
# Post Provisioning Task
 ## variables for SANDBOX:

```terraform
#commvault
$commvault_storageaccount         = "mcdmacfeeinstaller"
$commvault_container_name_window  = "windowsagent"
$commvault_container_name_linux   = "linuxagents"
$commvault_blob_name_linux        = "CommvaultLinuxAgentInstaller-11.el7_9.x86_64.rpm"
$vcplusinstaller                  = "vc_redist.x64.exe"
$commvault_blob_name_window       = "Commvaultinstaller.zip"
#Sentinal
$sentinal_storageaccount          = "mcdmacfeeinstaller"
$sentinal_container_name          = "mcdantivirus-sentinal"
$sentinal_storageblobname_window  = "SentinelAgent-windows"
$sentinal_storageblobname_linux   = "SentinelAgent-Linux.zip"

#wsus confiq
$target_group                     = "AZ-USA-PROD-B05"
$wu_server                        = "http://10.195.139.29:8530/"
$wu_status_server                 = "http://10.195.139.29:8530/"

#formatdrive
$driveformat                      = "NTFS"

#pp_csv_file_storage_container
$pp_container                     = "scripts"

#add group to local admin
$ad_groups                        = "corp\test1_group1,corp\test_group2"


```

 ## variables for PROD:


```terraform
 #commvault
$commvault_storageaccount         = "mcdposttaskprodstorage"
$commvault_container_name_window  = "windowsagent"
$commvault_container_name_linux   = "linuxagents"
$commvault_blob_name_linux        = "CommvaultLinuxAgentInstaller-11.el7_9.x86_64.rpm"
$vcplusinstaller                  = "vc_redist.x64.exe"
$commvault_blob_name_window       = "Commvaultinstaller.zip"
#Sentinal
$sentinal_storageaccount          = "mcdposttaskprodstorage"
$sentinal_container_name          = "mcdantivirus-sentinel"
$sentinal_storageblobname_window  = "SentinelAgent-windows"
$sentinal_storageblobname_linux   = "SentinelAgent-Linux.zip"

#wsus confiq
$target_group                     = "AZ-USA-PROD-B05"
$wu_server                        = "http://10.195.139.29:8530/"
$wu_status_server                 = "http://10.195.139.29:8530/"

#formatdrive
$driveformat                      = "NTFS"

#pp_csv_file_storage_container
$pp_container                     = "scripts"

#add group to local admin
$ad_groups                        = "corp\test1_group1,corp\test_group2"

#New Relic
$newrelic_storageaccount    = "mcdposttaskprodstorage"
$newrelic_container         = "newrelic"
$newrelic_blob                    = "newrelic-infra.msi"
$newrelic_blob_linux              = "newrelic-infra-1.20.7-1.el7.x86_64.rpm"
$newrelic_blob_postgresql         = "postgresql-libs-9.2.24-4.el7_8.x86_64.rpm"
$newrelic_blob_tdagent            = "td-agent-bit-1.8.6-1.centos-7.x86_64.rpm"

```
## variables for NONPROD:

```terraform
#commvault
$commvault_storageaccount         = "mcdpostnonprodstorage"
$commvault_container_name_window  = "windowsagent"
$commvault_container_name_linux   = "linuxagents"
$commvault_blob_name_linux        = "CommvaultLinuxAgentInstaller-11.el7_9.x86_64.rpm"
$vcplusinstaller                  = "vc_redist.x64.exe"
$commvault_blob_name_window       = "Commvaultinstaller.zip"
#Sentinal
$sentinal_storageaccount          = "mcdpostnonprodstorage"
$sentinal_container_name          = "mcdantivirus-sentinal"
$sentinal_storageblobname_window  = "SentinelAgent-windows"
$sentinal_storageblobname_linux   = "SentinelAgent-Linux.zip"

#wsus confiq
$target_group                     = "AZ-USA-PROD-B05"
$wu_server                        = "http://10.195.139.29:8530/"
$wu_status_server                 = "http://10.195.139.29:8530/"

#formatdrive
$driveformat                      = "NTFS"

#pp_csv_file_storage_container
$pp_container                     = "scripts"

#add group to local admin
$ad_groups                        = "corp\test1_group1,corp\test_group2"

#New Relic
$newrelic_storageaccount          = "mcdpostnonprodstorage"
$newrelic_container               = "newrelic"
$newrelic_blob                    = "newrelic-infra.msi"
$newrelic_blob_linux              = "newrelic-infra-1.20.7-1.el7.x86_64.rpm"
$newrelic_blob_postgresql         = "postgresql-libs-9.2.24-4.el7_8.x86_64.rpm"
$newrelic_blob_tdagent            = "td-agent-bit-1.8.6-1.centos-7.x86_64.rpm"
```
