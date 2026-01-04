terraform {
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "=2.97.0"
    }
  }
}

provider "azurerm" {
  features {}
}

resource "azurerm_resource_group" "vm-rg" {
  name     = "ubuntu-vm-resources"
  location = "westeurope"
  tags = {
    env = "dev"
  }
}

resource "azurerm_virtual_network" "ubuntu-vm-vn" {
  name                = "ubuntu-vm-network"
  resource_group_name = azurerm_resource_group.vm-rg.name
  location            = azurerm_resource_group.vm-rg.location
  address_space       = ["10.123.0.0/16"]
  tags = {
    env = "dev"
  }
}

resource "azurerm_subnet" "ubutnu-vm-subnet" {
  name                 = "ubuntu-subnet"
  resource_group_name  = azurerm_resource_group.vm-rg.name
  virtual_network_name = azurerm_virtual_network.ubuntu-vm-vn.name
  address_prefixes     = ["10.123.1.0/24"]
}


