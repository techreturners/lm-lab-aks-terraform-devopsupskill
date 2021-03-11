resource "random_string" "acr-random-name" {
  length        = 5
  special       = false
  upper         = false
  number        = false
  lower         = true
}

resource "azurerm_container_registry" "devops-upskill-registry" {
  name                = "devopsupskillregistry${random_string.acr-random-name.result}"
  resource_group_name = azurerm_resource_group.default.name
  location            = azurerm_resource_group.default.location
  sku                 = "Standard"
  admin_enabled       = true
}

# add the role to the identity the kubernetes cluster was assigned
resource "azurerm_role_assignment" "kubweb_to_acr" {
  scope                = azurerm_container_registry.devops-upskill-registry.id
  role_definition_name = "AcrPull"
  principal_id         = azurerm_kubernetes_cluster.default.kubelet_identity[0].object_id
}