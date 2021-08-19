variable "keycloak_url" {
  type = string
  default = "http://localhost:8080"
}

variable "keycloak_username" {
  type = string
}

variable "keycloak_password" {
  type = string
}

variable "keycloak_federation_realm_roles" {
  type    = map(any)
  default = {}
}

variable "demo_app_redirect_uris" {
  type = list
  default = ["https://kc-demo-app.irusu.uk/","*"]
}

variable "adfs_root_url" {
  type = string
  default = ""
}
variable "adfs_client_id" {
  type = string
  default = ""
}
variable "adfs_client_secret" {
  type = string
  default = ""
  sensitive = true
}
