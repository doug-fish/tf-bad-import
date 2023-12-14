provider "azurerm" {
  features {}
}

resource "azurerm_resource_group" "example" {
  for_each = toset(["example"])
  name     = each.key
  location = "Central US"
}
