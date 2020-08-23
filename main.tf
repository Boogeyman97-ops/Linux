provider "azurerm" {
  features {}
}

resource "azurerm_resource_group" "terraform_rgroup" {
  name     = "bm-resources"
  location = "East US"
}

resource "azurerm_virtual_network" "terraform_vnet" {
  name                = "bm-network"
  address_space       = ["10.0.0.0/16"]
  location            = azurerm_resource_group.terraform_rgroup.location
  resource_group_name = azurerm_resource_group.terraform_rgroup.name
}

resource "azurerm_subnet" "terraform_subnet" {
  name                 = "internal"
  resource_group_name  = azurerm_resource_group.terraform_rgroup.name
  virtual_network_name = azurerm_virtual_network.terraform_vnet.name
  address_prefix       = "10.0.2.0/24"
}

resource "azurerm_network_interface" "terraform_interface" {
  name                = "bm-nic"
  location            = azurerm_resource_group.terraform_rgroup.location
  resource_group_name = azurerm_resource_group.terraform_rgroup.name

  ip_configuration {
    name                          = "internal"
    subnet_id                     = azurerm_subnet.terraform_subnet.id
    private_ip_address_allocation = "Dynamic"
  }
}

resource "azurerm_linux_virtual_machine" "linux-1" {
  name                = "linux_machine"
  resource_group_name = azurerm_resource_group.terraform_rgroup.name
  location            = azurerm_resource_group.terraform_rgroup.location
  size                = "Standard_F2"
  admin_username      = "adminuser"
  network_interface_ids = [
    azurerm_network_interface.example.id,
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
