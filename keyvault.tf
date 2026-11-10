data "azurerm_client_config" "current" {}

# Mot de passe généré par OpenTofu : jamais écrit dans le code
resource "random_password" "main" {
  length           = 24
  special          = true
  override_special = "!#$%&*-_=+"
}

resource "azurerm_key_vault" "main" {
  name                       = "kv-nimbus-${var.binome}"
  resource_group_name        = azurerm_resource_group.main.name
  location                   = azurerm_resource_group.main.location
  tenant_id                  = data.azurerm_client_config.current.tenant_id
  sku_name                   = "standard"
  soft_delete_retention_days = 7
  purge_protection_enabled   = false
  tags                       = local.tags

  # Accès pour la personne qui déploie (celle connectée avec az login)
  access_policy {
    tenant_id = data.azurerm_client_config.current.tenant_id
    object_id = data.azurerm_client_config.current.object_id

    secret_permissions = ["Get", "List", "Set", "Delete", "Purge", "Recover"]
  }
}

resource "azurerm_key_vault_secret" "password" {
  name         = "mot-de-passe-nimbus"
  value        = random_password.main.result
  key_vault_id = azurerm_key_vault.main.id
  tags         = local.tags
}