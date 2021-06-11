provider "azurerm" {
  features {}
}

resource "azurerm_resource_group" "default" {
  name     = "${var.resourceGroupName}-rg"
  location = var.region

  tags = {
    environment = "Demo"
  }
}

resource "azurerm_kubernetes_cluster" "default" {
  name                = "${var.resourceGroupName}-aks"
  location            = azurerm_resource_group.default.location
  resource_group_name = azurerm_resource_group.default.name
  dns_prefix          = "${var.resourceGroupName}-k8s"

  default_node_pool {
    name            = "default"
    node_count      = 2
    vm_size         = "Standard_D2_v2"
    os_disk_size_gb = 30
  }

  # azure will assign the id automatically
  identity {
    type = "SystemAssigned"
  }

  role_based_access_control {
    enabled = true
  }

  tags = {
    environment = "Demo"
  }
}
