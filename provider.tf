terraform {
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "2.59.0"
    }
  }

  backend "azurerm" {
  }
}

provider "azurerm" {
  subscription_id = var.subscription_id
  features {}
}
