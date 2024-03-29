terraform {
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "3.41.0"
    }
  }
}

provider "azurerm" {

  features {}

}

resource "azurerm_resource_group" "example" {
  name     = "mygroup"
  location = "eastus"

  tags = {
    name        = "Terraform"
    environment = "test"
  }
}

resource "azurerm_virtual_network" "my-network" {
  depends_on          = [azurerm_resource_group.example]
  name                = "mynetwork"
  address_space       = ["10.1.0.0/16"]
  location            = azurerm_resource_group.example.location
  resource_group_name = azurerm_resource_group.example.name
}

resource "azurerm_subnet" "internal" {
  depends_on           = [azurerm_virtual_network.my-network]
  name                 = "internal"
  resource_group_name  = azurerm_resource_group.example.name
  virtual_network_name = azurerm_virtual_network.my-network.name
  address_prefixes     = ["10.1.0.0/16"]
}

resource "azurerm_network_security_group" "mysg" {
  depends_on          = [azurerm_resource_group.example, azurerm_virtual_network.my-network, azurerm_subnet.internal]
  name                = "allow_SSH_HTTP"
  location            = azurerm_resource_group.example.location
  resource_group_name = azurerm_resource_group.example.name

  security_rule {
    name                       = "allow_ssh"
    priority                   = 100
    direction                  = "Inbound"
    access                     = "Allow"
    protocol                   = "Tcp"
    source_port_range          = "*"
    destination_port_range     = "22"
    source_address_prefix      = "*"
    destination_address_prefix = "*"
  }


  security_rule {
    name                       = "allow_http"
    priority                   = 200
    direction                  = "Inbound"
    access                     = "Allow"
    protocol                   = "Tcp"
    source_port_range          = "*"
    destination_port_range     = "80"
    source_address_prefix      = "*"
    destination_address_prefix = "*"
  }


  tags = {
    environment = "Test"
  }
}


resource "azurerm_network_interface" "example" {
  depends_on          = [azurerm_network_security_group.mysg]
  name                = "my-nic"
  location            = azurerm_resource_group.example.location
  resource_group_name = azurerm_resource_group.example.name

  ip_configuration {
    name                          = "internal"
    subnet_id                     = azurerm_subnet.internal.id
    private_ip_address_allocation = "Dynamic"
  }
}

resource "azurerm_virtual_machine" "main" {
  name                  = "vm-through-terraform"
  location              = azurerm_resource_group.example.location
  resource_group_name   = azurerm_resource_group.example.name
  network_interface_ids = [azurerm_network_interface.example.id]
  vm_size               = "Standard_DS1_v2"

  storage_image_reference {
    publisher = "Canonical"
    offer     = "UbuntuServer"
    sku       = "16.04-LTS"
    version   = "latest"
  }
  storage_os_disk {
    name              = "myosdisk1"
    caching           = "ReadWrite"
    create_option     = "FromImage"
    managed_disk_type = "Standard_LRS"

  }

  os_profile {
        computer_name  = "hostname"
        admin_username = "testadmin"
        admin_password = "Password@123"
    }

 os_profile_linux_config {
    disable_password_authentication = false
  }

  tags = {
    environment = "Test"
  }


}


