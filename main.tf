terraform {
  required_providers {
    azurerm = {
      source = "hashicorp/azurerm"
      version = "3.49.0"
    }
  }
}

provider "azurerm" {
  subscription_id = "0651313e-dbf5-4736-ac89-dbe2383f4a7c"
  client_id       = "1ecc7f7a-6bf4-4dbc-a9c3-9a28e412f5e8"
  client_secret   = "tea8Q~WfpJaYQOzOEmZ8KS_Hos1NXPei0v~qobUq"
  tenant_id       = "94783a06-e193-44c2-8965-0ce21f3d080d"
  features {}
}

locals {
  resource_group="app-grp"
  location="East US"
}

resource "tls_private_key" "linux_key" {
  algorithm = "RSA"
  rsa_bits = 4096
}

resource "local_file" "linuxkey" {
  filename="linuxkey.pem"  
  content=tls_private_key.linux_key.private_key_pem 
}

resource "azurerm_resource_group" "app_grp"{
  name=local.resource_group
  location=local.location
}

resource "azurerm_virtual_network" "app_network" {
  name                = "app-network"
  location            = local.location
  resource_group_name = azurerm_resource_group.app_grp.name
  address_space       = ["10.0.0.0/16"]
}

resource "azurerm_subnet" "SubnetA" {
  name                 = "SubnetA"
  resource_group_name  = local.resource_group
  virtual_network_name = azurerm_virtual_network.app_network.name
  address_prefixes     = ["10.0.1.0/24"]
  depends_on = [
    azurerm_virtual_network.app_network
  ]
}

resource "azurerm_network_interface" "app_interface" {
  name                = "app-interface"
  location            = local.location
  resource_group_name = local.resource_group
  ip_configuration {
    name                          = "internal"
    subnet_id                     = azurerm_subnet.SubnetA.id
    private_ip_address_allocation = "Dynamic"
    public_ip_address_id = azurerm_public_ip.app_public_ip.id
  }
  depends_on = [
    azurerm_virtual_network.app_network,
    azurerm_public_ip.app_public_ip
  ]
}

resource "azurerm_linux_virtual_machine" "linux_vm" {
  name                = "linuxvm"
  resource_group_name = local.resource_group
  location            = local.location
  size                = "Standard_D2s_v3"
  admin_username      = "linuxusr"  
  network_interface_ids = [
    azurerm_network_interface.app_interface.id,
  ]
  admin_ssh_key {
    username   = "linuxusr"
    public_key = tls_private_key.linux_key.public_key_openssh
  }
  os_disk {
    caching              = "ReadWrite"
    storage_account_type = "Standard_LRS"
  }
  source_image_reference {
    publisher = "Canonical"
    offer     = "UbuntuServer"
    sku       = "18.04-LTS"
    version   = "latest"
  }
  depends_on = [
    azurerm_network_interface.app_interface,
    tls_private_key.linux_key
  ]
}

resource "azurerm_public_ip" "app_public_ip" {
  name                = "app-public-ip"
  resource_group_name = local.resource_group
  location            = local.location
  allocation_method   = "Static"
  depends_on = [
    azurerm_resource_group.app_grp
  ]
}

resource "azurerm_storage_account" "storage_account" {
  name                     = "privatekeystore10090"
  resource_group_name      = local.resource_group
  location                 = local.location
  account_tier             = "Standard"
  account_replication_type = "LRS"
  depends_on = [
    azurerm_resource_group.app_grp
  ]
}

resource "azurerm_storage_container" "credentials" {
  name                  = "credentials"
  storage_account_name  = azurerm_storage_account.storage_account.name
  container_access_type = "private"
  depends_on = [
    azurerm_resource_group.app_grp,
    azurerm_storage_account.storage_account
  ]
}

resource "azurerm_storage_blob" "key" {
  name                   = "linuxkey.pem"
  storage_account_name   = azurerm_storage_account.storage_account.name
  storage_container_name = azurerm_storage_container.credentials.name
  type                   = "Block"
  source                 = "linuxkey.pem"
  depends_on = [
    azurerm_resource_group.app_grp,
    azurerm_storage_account.storage_account,
    azurerm_storage_container.credentials,
    azurerm_linux_virtual_machine.linux_vm
  ]
}

output "public_ip" {
  value = azurerm_public_ip.app_public_ip.ip_address
}
