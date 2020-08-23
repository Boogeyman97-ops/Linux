provider "azurerm" {
  features {}
}

resource "azurerm_resource_group" "r1" {
  name     = "r1-resources"
  location = "West Europe"
}

resource "azurerm_virtual_network" "v1" {
  name                = "v1-network"
  address_space       = ["10.0.0.0/16"]
  location            = azurerm_resource_group.r1.location
  resource_group_name = azurerm_resource_group.r1.name
}

resource "azurerm_subnet" "sb1" {
  name                 = "internal"
  resource_group_name  = azurerm_resource_group.r1.name
  virtual_network_name = azurerm_virtual_network.v1.name
  address_prefix       = "10.0.2.0/24"
}

resource "azurerm_network_interface" "i1" {
  name                = "i1-nic"
  location            = azurerm_resource_group.r1.location
  resource_group_name = azurerm_resource_group.r1.name

  ip_configuration {
    name                          = "internal"
    subnet_id                     = azurerm_subnet.sb1.id
    private_ip_address_allocation = "Dynamic"
  }
}

resource "azurerm_linux_virtual_machine" "l1" {
  name                = "l1-machine"
  resource_group_name = azurerm_resource_group.r1.name
  location            = azurerm_resource_group.r1.location
  size                = "Standard_F2"
  admin_username      = "adminuser"
  network_interface_ids = [
    azurerm_network_interface.i1.id,
  ]

  admin_ssh_key {
    username   = "adminuser"
    public_key = file("~/.ssh/id_rsa.pub")
  }

  os_disk {
    caching              = "ReadWrite"
    storage_account_type = "Standard_LRS"
  }

  source_image_reference {
    publisher = "Canonical"
    offer     = "UbuntuServer"
    sku       = "16.04-LTS"
    version   = "latest"
  }
}
