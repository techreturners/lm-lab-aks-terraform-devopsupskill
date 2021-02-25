variable "appId" {
  description = "Azure Kubernetes Service Cluster service principal"
}

variable "password" {
  description = "Azure Kubernetes Service Cluster password"
}

variable "region" {
  description = "Azure region to utilise"
  default     = "uksouth"
}

variable "resourceGroupName" {
  description = "Azure resource group name to utilise"
  default     = "devops-upskill"
}
