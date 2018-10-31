variable google_region {
  description = "Google Cloud Platform region"
  type        = "string"
}

variable google_network {
  description = "Name of the Google Cloud VPC network"
  type        = "string"
}

variable google_network_auto_create_subnetworks {
  description = "Auto-create one subnet in each region for the Google Cloud VPC network"
  type        = "string"
  default     = false
}

variable google_subnetwork {
  description = "Name of the Google subnetwork"
  type        = "string"
}

variable google_subnetwork_cidr_block {
  description = "Google subnet IP address range"
  type        = "string"
}

variable google_subnetwork_private_ip_access {
  description = "Google subnet IP address range"
  type        = "string"
  default     = false
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
