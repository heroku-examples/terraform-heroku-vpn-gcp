provider "google" {
  version = "~> 1.19"
  region  = "${var.google_region}"
}

provider "heroku" {
  version = "~> 1.5"
}

module "heroku_vpn_gcp" {
  source = "../../"

  // Google Cloud Platform config
  google_region                          = "${var.google_region}"
  google_network                         = "${var.google_network}"
  google_network_auto_create_subnetworks = "${var.google_network_auto_create_subnetworks}"
  google_subnetwork                      = "${var.google_subnetwork}"
  google_subnetwork_cidr_block           = "${var.google_subnetwork_cidr_block}"
  google_subnetwork_private_ip_access    = "${var.google_subnetwork_private_ip_access}"

  // Heroku Private Space config
  vpn_remote_cidr_block       = "${heroku_space_vpn_connection.google.space_cidr_block}"
  vpn_ike_version             = "${heroku_space_vpn_connection.google.ike_version}"
  vpn_tunnel_ip_0             = "${heroku_space_vpn_connection.google.tunnels.0.ip}"
  vpn_tunnel_pre_shared_key_0 = "${heroku_space_vpn_connection.google.tunnels.0.pre_shared_key}"
  vpn_tunnel_ip_1             = "${heroku_space_vpn_connection.google.tunnels.1.ip}"
  vpn_tunnel_pre_shared_key_1 = "${heroku_space_vpn_connection.google.tunnels.1.pre_shared_key}"

  providers = {
    google = "google"
  }
}

resource "heroku_space" "default" {
  name         = "${var.heroku_private_space}"
  organization = "${var.heroku_enterprise_team}"
  region       = "${var.heroku_private_space_region}"
}

resource "heroku_space_vpn_connection" "google" {
  name           = "${var.heroku_vpn}"
  space          = "${heroku_space.default.id}"
  public_ip      = "${module.heroku_vpn_gcp.google_vpn_ip}"
  routable_cidrs = ["${module.heroku_vpn_gcp.google_cidr_block}"]
}
