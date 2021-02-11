# We strongly recommend using the required_providers block to set the
# Azure Provider source and version being used
terraform {
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "=2.46.0"
    }
  }
}

# Configure the Microsoft Azure Provider
provider "azurerm" {
  features {}
}

# Create a resource group
resource "azurerm_resource_group" "example" {
  name     = "test-rg"
  location = "West Europe"
}

resource "azurerm_virtual_network" "example" {
  name                = "virtnetname"
  address_space       = ["10.0.0.0/16"]
  location            = azurerm_resource_group.example.location
  resource_group_name = azurerm_resource_group.example.name
}

resource "azurerm_subnet" "example" {
  name                 = "subnetname"
  resource_group_name  = azurerm_resource_group.example.name
  virtual_network_name = azurerm_virtual_network.example.name
  address_prefixes     = ["10.0.2.0/24"]
}
}

resource "azurerm_storage_account" "example" {
  name                     = "storageaccountname"
  resource_group_name      = azurerm_resource_group.example.name
  location                 = azurerm_resource_group.example.location
  account_tier             = "Standard"
  account_replication_type = "GRS"

  tags = {
    environment = "staging"
  }
}


data "azurerm_subscription" "current" {
}

resource "azurerm_management_group" "example_parent" {
  display_name = "ParentGroup"

  subscription_ids = [
    data.azurerm_subscription.current.subscription_id,
  ]
}

resource "azurerm_management_group" "example_child" {
  display_name               = "ChildGroup"
  parent_management_group_id = azurerm_management_group.example_parent.id

  subscription_ids = [
    data.azurerm_subscription.current.subscription_id,
  ]
  # other subscription IDs can go here
}