variable "heroku_enterprise_team" {
  description = "Name of the Enterprise Team (must already exist)"
  type        = string
}

variable "heroku_private_space" {
  description = "Name of the Private Space"
  type        = string
}

variable "heroku_private_space_region" {
  description = "Private Spaces region"
  type        = string
  default     = "oregon"
}

variable "heroku_vpn" {
  description = "Name of the Private Space VPN Connection"
  type        = string
  default     = "google"
}

variable "google_region" {
  description = "Google Cloud Platform region"
  type        = string
  default     = "us-west1"
}

variable "google_network" {
  description = "Name of the Google Cloud VPC network"
  type        = string
  default     = "heroku-private"
}

variable "google_network_auto_create_subnetworks" {
  description = "Auto-create one subnet in each region for the Google Cloud VPC network"
  type        = string
  default     = false
}

variable "google_subnetwork" {
  description = "Name of the Google subnetwork"
  type        = string
  default     = "heroku-private-subnet"
}

variable "google_subnetwork_cidr_block" {
  description = "Google subnet IP address range"
  type        = string
  default     = "10.127.0.0/20"
}

variable "google_subnetwork_private_ip_access" {
  description = "Google Cloud API access from private IPs"
  type        = string
  default     = false
}
