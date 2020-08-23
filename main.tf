resource "azurerm_resource_group" "terraform_linux_grp" {
  name     = "bm-resources"
  location = "West Europe"
}

resource "azurerm_virtual_network" "terraform_linux_vnet" {
  name                = "bm-network"
  address_space       = ["10.0.0.0/16"]
  location            = azurerm_resource_group.terraform_linux_grp.location
  resource_group_name = azurerm_resource_group.terraform_linux_grp.name
}

resource "azurerm_subnet" "terraform_linux_subnet" {
  name                 = "internal"
  resource_group_name  = azurerm_resource_group.terraform_linux_grp.name
  virtual_network_name = azurerm_virtual_network.terraform_linux_vnet.name
  address_prefix       = "10.0.2.0/24"
}

resource "azurerm_network_interface" "terraform_linux_interface" {
  name                = "bm-nic"
  location            = azurerm_resource_group.terraform_linux_grp.location
  resource_group_name = azurerm_resource_group.terraform_linux_grp.name

  ip_configuration {
    name                          = "internal"
    subnet_id                     = azurerm_subnet.terraform_linux_subnet.id
    private_ip_address_allocation = "Dynamic"
  }
}

resource "azurerm_linux_virtual_machine" "example" {
  name                = "example-machine"
  resource_group_name = azurerm_resource_group.example.name
  location            = azurerm_resource_group.example.location
  size                = "Standard_F2"
  admin_username      = "adminuser"
  network_interface_ids = [
    azurerm_network_interface.example.id,
  ]

  os_profile {
    computer_name  = "hostname"
    admin_username = "terraformlinuxadminuser"
    admin_password = "Hindustan1945"
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
