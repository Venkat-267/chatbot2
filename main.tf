provider "azurerm" {
  features {}
  subscription_id = "d7ebd1a3-506e-4870-b872-38bf70130d51"
}

resource "azurerm_container_group" "aci" {
  name                = var.aci_name
  location            = var.location
  resource_group_name = var.resource_group

  os_type        = "Linux"
  restart_policy = "Always"

  dns_name_label = var.dns_name_label  # Publicly accessible DNS

  container {
    name   = var.aci_name
    image  = "${var.acr_login_server}/${var.image_name}:${var.image_version}"
    cpu    = var.cpu_count
    memory = var.memory_gb

    ports {
      port     = var.port_number
      protocol = "TCP"
    }
  }

  image_registry_credential {
    server   = var.acr_login_server
    username = var.acr_name
    password = var.acr_password
  }
}
