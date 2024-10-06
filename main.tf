terraform {
  required_providers {
    azurerm = {
        source = "hashicorp/azurerm"
        version = "3.111.0"
    }
  }
}

provider "azurerm" {
  
  features {
    
  }
}

resource "azurerm_resource_group" "this" {
    name = "NingAzure"
    location = "westeurope"
  
}

resource "azurerm_databricks_workspace" "this" {
    name = "NingDatabricks"
    resource_group_name = azurerm_resource_group.this.name
    location = azurerm_resource_group.this.location
    sku = "premium"
    managed_resource_group_name = "NingAzure_mrg"
  
}

output "databricks_host" {
    value = "https://${azurerm_databricks_workspace.this.workspace_url}"
}
