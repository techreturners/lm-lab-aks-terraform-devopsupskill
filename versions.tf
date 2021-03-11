terraform {
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "2.48.0"
    }

    # Random is used to try and make the ACR registry name is globally unique to Azure
    random = {
      source = "hashicorp/random"
      version = "3.1.0"
    }
  }

  required_version = "~> 0.14"
}

