terraform {
  required_providers {
    keycloak = {
      source  = "mrparkers/keycloak"
      version = ">= 3.0"
    }
  }
}

provider "keycloak" {
  client_id = "admin-cli"
  url       = var.keycloak_url
  username  = var.keycloak_username
  password  = var.keycloak_password
}

resource "keycloak_realm" "realm_federation_demo" {
    realm = "federation-demo"
    display_name = "ADFS Demo Realm" 
}

resource "keycloak_role" "realm_roles" {
    realm_id = keycloak_realm.realm_federation_demo.id
    for_each = var.keycloak_federation_realm_roles 
      name                       = each.value.name
      description = each.value.description
  
}

resource "keycloak_openid_client" "hosted_app_client" {
    realm_id = keycloak_realm.realm_federation_demo.id
    client_id = "demo-application"
    name = "Demo Application"
    valid_redirect_uris = var.demo_app_redirect_uris
    access_type = "PUBLIC"
    standard_flow_enabled = true
    direct_access_grants_enabled = true
    web_origins = ["*"]
}

resource "keycloak_oidc_identity_provider" "adfs_identity_provider" {
    realm = keycloak_realm.realm_federation_demo.id
    alias = "adfs"
    display_name = "Third Party ADFS Server"
    store_token = false
    authorization_url = "${var.adfs_root_url}/adfs/oauth2/authorize/"
    client_id = var.adfs_client_id
    client_secret = var.adfs_client_secret
    token_url = "${var.adfs_root_url}/adfs/oauth2/token/"
    logout_url = "${var.adfs_root_url}/adfs/oauth2/logout"
    disable_user_info = true
    user_info_url = "${var.adfs_root_url}/adfs/userinfo"
    jwks_url = "${var.adfs_root_url}/adfs/discovery/keys"
    validate_signature = true
    backchannel_supported = false
    sync_mode = "IMPORT"
    extra_config = {
      "clientAuthMethod" = "client_secret_post"
      "issuer" = "${var.adfs_root_url}/adfs"
    }
}
