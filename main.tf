# Create a resource group if it doesn't exist
resource "azurerm_resource_group" "BOSS" {
  name     = var.resource_group_name
  location = var.resource_group_location

  tags = {
    environment = "demo"
  }
}

resource "azurerm_virtual_network" "AVP" {
  name                = var.virtual_network_name
  address_space       = ["10.0.0.0/16"]
  location            = azurerm_resource_group.BOSS.location
  resource_group_name = azurerm_resource_group.BOSS.name
}

resource "azurerm_subnet" "internal" {
  name                 = var.subnet_name
  resource_group_name  = azurerm_resource_group.BOSS.name
  virtual_network_name = azurerm_virtual_network.AVP.name
  address_prefixes     = ["10.0.2.0/24"]
}

resource "azurerm_public_ip" "BOSSIP" {
    name                         = var.public_ip_name
    location                     = "West Europe"
    resource_group_name          = azurerm_resource_group.BOSS.name
    allocation_method            = "Dynamic"
}

resource "azurerm_network_interface" "VPP" {
  name                = var.network_interface_name
  location            = azurerm_resource_group.BOSS.location
  resource_group_name = azurerm_resource_group.BOSS.name

  ip_configuration {
    name                          = "testconfiguration1"
    subnet_id                     = azurerm_subnet.internal.id
    private_ip_address_allocation = "Dynamic"
    public_ip_address_id          = azurerm_public_ip.BOSSIP.id
  }
}

resource "azurerm_linux_virtual_machine" "MUMBAI" {
    name                  = var.vm_name
    location              = "West Europe"
    resource_group_name   = azurerm_resource_group.BOSS.name
    network_interface_ids = [azurerm_network_interface.VPP.id]
    size                  = var.vm_size

    os_disk {
        name              = var.os_disk
        caching           = "ReadWrite"
        storage_account_type = "Premium_LRS"
    }

    source_image_reference {
        publisher = "Canonical"
        offer     = "UbuntuServer"
        sku       = "18.04-LTS"
        version   = "latest"
    }
    computer_name  = var.computer_name
    admin_username = var.admin_username
    disable_password_authentication = false
    admin_password = var.admin_password

    

    tags = {
        environment = "demo"
    }
   
}
