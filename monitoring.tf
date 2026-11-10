resource "azurerm_monitor_action_group" "mail" {
  name                = "ag-nimbus-${var.binome}"
  resource_group_name = azurerm_resource_group.main.name
  short_name          = "nimbus-g5"
  tags                = local.tags

  email_receiver {
    name          = "alerte-mail"
    email_address = var.alert_email
  }
}

# Une alerte par VM web : CPU moyen > 80 % sur 5 minutes
resource "azurerm_monitor_metric_alert" "cpu" {
  count               = 2
  name                = "alert-cpu-nimbus-${var.binome}-${count.index + 1}"
  resource_group_name = azurerm_resource_group.main.name
  scopes              = [azurerm_linux_virtual_machine.web[count.index].id]
  description         = "CPU supérieur à 80 % pendant 5 minutes"
  severity            = 2
  frequency           = "PT1M"
  window_size         = "PT5M"
  tags                = local.tags

  criteria {
    metric_namespace = "Microsoft.Compute/virtualMachines"
    metric_name      = "Percentage CPU"
    aggregation      = "Average"
    operator         = "GreaterThan"
    threshold        = 80
  }

  action {
    action_group_id = azurerm_monitor_action_group.mail.id
  }
}