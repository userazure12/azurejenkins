# Configure the Microsoft Azure Provider
terraform {
  required_providers {
    azurerm = {
      source = "hashicorp/azurerm"
      version = "~>2.0"
    }
  }
}
provider "azurerm" {
  features { }
  client_secret = "6So7Q~ZhXM7ZqXUT2FmTlifqQUaiA-FkHK9X5"
  client_id = "19a76c00-37ef-426b-aded-233b74ff4759"
  tenant_id = "eeeb6497-738c-49c7-b0cd-68cd0669e13d"
  subscription_id = "a680f040-a5db-4a85-b40f-61bf75c5aa4c"
}
