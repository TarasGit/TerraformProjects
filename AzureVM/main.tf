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
  address_space       = ["10.1.0.0/16"]
  tags = {
    env = "dev"
  }
}

resource "azurerm_subnet" "ubutnu-vm-subnet" {
  name                 = "ubuntu-subnet"
  resource_group_name  = azurerm_resource_group.vm-rg.name
  virtual_network_name = azurerm_virtual_network.ubuntu-vm-vn.name
  address_prefixes     = ["10.1.1.0/24"]
}

resource "azurerm_network_security_group" "ubuntu-sg" {
  name                = "ubuntu-sg"
  location            = azurerm_resource_group.vm-rg.location
  resource_group_name = azurerm_resource_group.vm-rg.name
  tags = {
    environment = "dev"
  }
}

resource "azurerm_network_security_rule" "ubuntu-sr" {
  name                        = "ubutnu-sr"
  priority                    = 100
  direction                   = "Inbound"
  access                      = "Allow"
  protocol                    = "*"
  source_port_range           = "*"
  destination_port_range      = "*"
  source_address_prefix       = "*"
  destination_address_prefix  = "*"
  resource_group_name         = azurerm_network_security_group.ubuntu-sg.name
  network_security_group_name = azurerm_network_security_group.ubuntu-sg.name
}