variable heroku_enterprise_team {
  description = "Name of the Enterprise Team (must already exist)"
  type        = "string"
}

variable heroku_private_space {
  description = "Name of the Private Space"
  type        = "string"
}

variable heroku_private_space_region {
  description = "Private Spaces region"
  type        = "string"
  default     = "oregon"
}

variable heroku_vpn {
  description = "Name of the Private Space VPN Connection"
  type        = "string"
  default     = "google"
}

variable google_region {
  description = "Google Compute Platform region"
  type        = "string"
  default     = "us-west1"
}

variable google_network {
  description = "Name of the Google Compute Network"
  type        = "string"
  default     = "heroku-private"
}

variable google_cidr_block {
  description = "Google subnet"
  type        = "string"
  default     = "10.127.0.0/20"
}
