
variable "subscription_id" {
    description = "SUBSCRIPTION ID "
    type = any
}


variable "kvrs" {
    description = "RG for Key Vault"
    type = string
}

variable "kvname" {
    description = "Name of Key Vault"
    type = string
}

variable "tags" {
    description = "tags"
    type = any
}

variable "vm_data" {
  type = any
}

variable "rg_data" {
  type = any
  default = {}
}

variable "availabilty_set" {
   type = any
  default = {}
}   
    

variable "storage_container" {
    description = "conatainer for centify server package"
    type = string
}
variable "storage_blobname" {
    description = "Blob for centify server package"
    type = string
}
