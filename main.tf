resource "tls_private_key" "linux_key" {
  algorithm = "RSA"
  rsa_bits  = 4096
}

resource "local_file" "linuxkey" {
  filename = var.local_file_name
  content  = tls_private_key.linux_key.private_key_pem
}

resource "azurerm_resource_group" "app_grp" {
  name     = var.resource_group_name
  location = var.resource_group_location
}

resource "azurerm_virtual_network" "app_network" {
  name                = var.virtual_network_name
  location            = azurerm_resource_group.app_grp.location
  resource_group_name = azurerm_resource_group.app_grp.name
  address_space       = ["10.0.0.0/16"]
}

resource "azurerm_subnet" "SubnetA" {
  name                 = var.subnet_name
  resource_group_name  = azurerm_resource_group.app_grp.name
  virtual_network_name = azurerm_virtual_network.app_network.name
  address_prefixes     = ["10.0.1.0/24"]
}

resource "azurerm_network_security_group" "nsg" {
  name                = var.network_security_group_name
  location            = azurerm_resource_group.app_grp.location
  resource_group_name = azurerm_resource_group.app_grp.name
  security_rule {
    name                       = "SSH"
    priority                   = 1001
    direction                  = "Inbound"
    access                     = "Allow"
    protocol                   = "Tcp"
    source_port_range          = "*"
    destination_port_range     = "22"
    source_address_prefix      = "*"
    destination_address_prefix = "*"
  }
}

resource "azurerm_network_interface" "app_interface" {
  name                = var.network_interface_name
  location            = azurerm_resource_group.app_grp.location
  resource_group_name = azurerm_resource_group.app_grp.name
  ip_configuration {
    name                          = "internal"
    subnet_id                     = azurerm_subnet.SubnetA.id
    private_ip_address_allocation = "Dynamic"
    public_ip_address_id          = azurerm_public_ip.app_public_ip.id
  }
}

resource "azurerm_network_interface_security_group_association" "ni_sg_association" {
  network_interface_id      = azurerm_network_interface.app_interface.id
  network_security_group_id = azurerm_network_security_group.nsg.id
}

resource "azurerm_linux_virtual_machine" "linux_vm" {
  name                            = var.virtual_machine_name
  resource_group_name             = azurerm_resource_group.app_grp.name
  location                        = azurerm_resource_group.app_grp.location
  size                            = "Standard_D2s_v3"
  computer_name                   = "myvm"
  admin_username                  = var.username
  disable_password_authentication = true
  network_interface_ids           = [azurerm_network_interface.app_interface.id]
  admin_ssh_key {
    username   = var.username
    public_key = tls_private_key.linux_key.public_key_openssh
  }
  os_disk {
    name                 = "myOsDisk"
    caching              = "ReadWrite"
    storage_account_type = "Standard_LRS"
  }
  source_image_reference {
    publisher = "Canonical"
    offer     = "UbuntuServer"
    sku       = "20.04-LTS"
    version   = "latest"
  }
  depends_on = [
    azurerm_network_interface_security_group_association.ni_sg_association
  ] 
}

resource "azurerm_public_ip" "app_public_ip" {
  name                = var.public_ip_name
  resource_group_name = azurerm_resource_group.app_grp.name
  location            = azurerm_resource_group.app_grp.location
  allocation_method   = "Static"
}

resource "azurerm_storage_account" "storage_account" {
  name                     = var.storage_account_name
  resource_group_name      = azurerm_resource_group.app_grp.name
  location                 = azurerm_resource_group.app_grp.location
  account_tier             = "Standard"
  account_replication_type = "LRS"
}

resource "azurerm_storage_container" "credentials" {
  name                  = var.storage_container_name
  storage_account_name  = azurerm_storage_account.storage_account.name
  container_access_type = "private"
}

resource "azurerm_storage_blob" "key" {
  name                   = var.storage_blob_name
  storage_account_name   = azurerm_storage_account.storage_account.name
  storage_container_name = azurerm_storage_container.credentials.name
  type                   = "Block"
  source                 = var.local_file_name
  depends_on = [
    azurerm_linux_virtual_machine.linux_vm
  ]
}
