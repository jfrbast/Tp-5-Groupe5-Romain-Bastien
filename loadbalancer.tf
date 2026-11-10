resource "azurerm_public_ip" "lb" {
  name                = "pip-nimbus-${var.binome}"
  resource_group_name = azurerm_resource_group.main.name
  location            = azurerm_resource_group.main.location
  allocation_method   = "Static"
  sku                 = "Standard"
  tags                = local.tags
}

resource "azurerm_lb" "main" {
  name                = "lb-nimbus-${var.binome}"
  resource_group_name = azurerm_resource_group.main.name
  location            = azurerm_resource_group.main.location
  sku                 = "Standard"
  tags                = local.tags

  frontend_ip_configuration {
    name                 = "frontend"
    public_ip_address_id = azurerm_public_ip.lb.id
  }
}

resource "azurerm_lb_backend_address_pool" "web" {
  name            = "pool-web"
  loadbalancer_id = azurerm_lb.main.id
}

# Sonde de santé : GET /sante sur le port 80
resource "azurerm_lb_probe" "sante" {
  name                = "probe-sante"
  loadbalancer_id     = azurerm_lb.main.id
  protocol            = "Http"
  port                = 80
  request_path        = "/sante"
  interval_in_seconds = 5
  number_of_probes    = 2
}

# Règle entrante : port 80 vers le pool
resource "azurerm_lb_rule" "http" {
  name                           = "rule-http"
  loadbalancer_id                = azurerm_lb.main.id
  protocol                       = "Tcp"
  frontend_port                  = 80
  backend_port                   = 80
  frontend_ip_configuration_name = "frontend"
  backend_address_pool_ids       = [azurerm_lb_backend_address_pool.web.id]
  probe_id                       = azurerm_lb_probe.sante.id
  disable_outbound_snat          = true
}

# Accès sortant explicite pour les VM web
resource "azurerm_lb_outbound_rule" "web" {
  name                    = "outbound-web"
  loadbalancer_id         = azurerm_lb.main.id
  protocol                = "All"
  backend_address_pool_id = azurerm_lb_backend_address_pool.web.id

  frontend_ip_configuration {
    name = "frontend"
  }
}

# Les 2 NIC rejoignent le pool backend
resource "azurerm_network_interface_backend_address_pool_association" "web" {
  count                   = 2
  network_interface_id    = azurerm_network_interface.web[count.index].id
  ip_configuration_name   = "internal"
  backend_address_pool_id = azurerm_lb_backend_address_pool.web.id
}