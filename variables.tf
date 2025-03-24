variable "resource_group" { default = "my-frontend-container" }
variable "location" { default = "Central India" }
variable "aci_name" { default = "policebot-container" }
variable "image_name" { default = "chaty/hello-world" }
variable "image_version" { default = "latest" }
variable "cpu_count" { default = "1" }
variable "memory_gb" { default = "2" }
variable "port_number" { default = "80" }
variable "acr_login_server" { default = "chatyregistry.azurecr.io" }
variable "acr_name" { default = "chatyregistry" }
variable "acr_password" {}
variable "dns_name_label" {
  description = "The DNS label for accessing the container."
  type        = string
  default="policebot-container"
}