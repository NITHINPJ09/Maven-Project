terraform {
  backend "azurerm" {
    resource_group_name  = "AI-102"
    storage_account_name = "mavenproject100sa2023"
    container_name       = "terraform"
    key                  = "terraform.tfstate"
    access_key           = "tkWvKbDxpY3TIyycbb8xEoPVDrQvQmwVtWsEw0YNd19UxIoAIJNj3UlQHcCCA+YD8AI/mhZqWqCv+AStkehJEQ="
  }
}
