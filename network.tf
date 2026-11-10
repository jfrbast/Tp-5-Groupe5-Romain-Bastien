resource "azurerm_resource_group" "main" {
  name     = "rg-nimbus-${var.binome}"
  location = var.location
  tags     = local.tags
}

resource "azurerm_virtual_network" "main" {
  name                = "vnet-nimbus-${var.binome}"
  resource_group_name = azurerm_resource_group.main.name
  location            = azurerm_resource_group.main.location
  address_space       = ["10.${var.numero_groupe}.0.0/16"]
  tags                = local.tags
}

resource "azurerm_subnet" "web" {
  name                 = "snet-web"
  resource_group_name  = azurerm_resource_group.main.name
  virtual_network_name = azurerm_virtual_network.main.name
  address_prefixes     = ["10.${var.numero_groupe}.1.0/24"]
}

resource "azurerm_subnet" "admin" {
  name                 = "snet-admin"
  resource_group_name  = azurerm_resource_group.main.name
  virtual_network_name = azurerm_virtual_network.main.name
  address_prefixes     = ["10.${var.numero_groupe}.2.0/24"]
}