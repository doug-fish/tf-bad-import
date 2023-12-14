This Terraform workspace demonstrates Terraform falsely claiming success on an import with a non-existent index. The file main.tfvars has this content:
```
provider "azurerm" {
  features {}
}

resource "azurerm_resource_group" "example" {
  for_each = toset(["example"])
  name     = each.key
  location = "Central US"
}
```
This workspace can generate it's default Azure Resource Group on apply, giving a single item in state
```
terraform state list
azurerm_resource_group.example["example"]
```
Attempting to import a second resource into this environment with a non-existent index claims success:
```
terraform import 'azurerm_resource_group.example["example2"]' '/subscriptions/[sub id redacted]/resourceGroups/example2'

Import successful!

The resources that were imported are shown above. These resources are now in
your Terraform state and will henceforth be managed by Terraform.
```
But the success is a lie. No extra resource is in state:
```
terraform state list
azurerm_resource_group.example["example"]
```
I perceive proper behavior to be that the import should issue an error message for this case.
