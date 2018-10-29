variable google_region {
  description = "Google Compute Platform region"
  type        = "string"
}

variable google_network {
  description = "Name of the Google Compute Network"
  type        = "string"
}

variable vpn_remote_cidr_block {
  description = "Heroku Private Space dyno network"
  type        = "string"
}

variable vpn_ike_version {
  description = "Heroku Private Space VPN's key exhange version"
  type        = "string"
}

variable vpn_tunnel_ip_0 {
  description = "Heroku Private Space VPN tunnel's IP address"
  type        = "string"
}

variable vpn_tunnel_pre_shared_key_0 {
  description = "Heroku Private Space VPN tunnel's secret key"
  type        = "string"
}

variable vpn_tunnel_ip_1 {
  description = "Heroku Private Space VPN tunnel's IP address"
  type        = "string"
}

variable vpn_tunnel_pre_shared_key_1 {
  description = "Heroku Private Space VPN tunnel's secret key"
  type        = "string"
}
