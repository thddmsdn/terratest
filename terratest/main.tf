# create resource group
resource "azurerm_resource_group" "RG" {
  name     = var.resource_group_name
  location = var.resource_group_location
}

# create virtual network
resource "azurerm_virtual_network" "testVNET" {
    name                = "test-vnet"
    resource_group_name = azurerm_resource_group.RG.name
    address_space       = ["192.168.0.0/16"]
    location            = azurerm_resource_group.RG.location
}  

# create subnet
resource "azurerm_subnet" "testsub" {
    name = "test-sub"
    resource_group_name = azurerm_resource_group.RG.name
    virtual_network_name = azurerm_virtual_network.testVNET.name
    address_prefixes = ["192.168.0.0/24"]
  
}

# create network interface
resource "azurerm_network_interface" "testnic" {
    name                = "test-nic"
    location            = azurerm_resource_group.RG.location
    resource_group_name = azurerm_resource_group.RG.name
    
    
    ip_configuration {
      name                          = "test-sub"
      subnet_id                     = azurerm_subnet.testsub.id  
      private_ip_address_allocation = "Dynamic"
    }
}

# create virtual machine
resource "azurerm_windows_virtual_machine" "testvm" {
    name = "test-vm"
    resource_group_name = azurerm_resource_group.RG.name
    location = azurerm_resource_group.RG.location
    size = "Standard_B2s"
    admin_username = "eunwoo"
    admin_password = "dkagh1.dkagh1."
    network_interface_ids = [
        azurerm_network_interface.testnic.id
    ]  

    os_disk {
        caching = "ReadWrite"
        storage_account_type = "Standard_LRS"
    }
    source_image_reference {
        publisher = "MicrosoftWindowsServer"
        offer     = "WindowsServer"
        sku       = "2016-Datacenter"
        version   = "latest"
    }
}
