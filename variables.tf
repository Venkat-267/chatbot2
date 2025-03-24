variable "resource_group" { default = "myResourceGroup" }
variable "location" { default = "East US" }
variable "aci_name" { default = "nginx-container" }
variable "image_name" { default = "nginx-frontend" }
variable "image_version" { default = "latest" }
variable "cpu_count" { default = "1" }
variable "memory_gb" { default = "2" }
variable "port_number" { default = "80" }
variable "acr_login_server" { default = "chatyregistry.azurecr.io" }
variable "acr_name" { default = "chatyregistry" }
variable "acr_password" {}
