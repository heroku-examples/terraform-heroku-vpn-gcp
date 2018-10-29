resource "google_compute_network" "default" {
  name                    = "${var.google_network}"
  description             = "terraform-heroku-vpn-gcp"
  auto_create_subnetworks = "false"
}

resource "google_compute_subnetwork" "default" {
  name                     = "${var.google_network}-subnet"
  ip_cidr_range            = "${var.google_cidr_block}"
  network                  = "${google_compute_network.default.self_link}"
  region                   = "${var.google_region}"
  private_ip_google_access = false
}

resource "google_compute_firewall" "allow-ssh" {
  name    = "${var.google_network}-allow-ssh"
  network = "${google_compute_network.default.name}"

  allow {
    protocol = "tcp"
    ports    = ["22"]
  }

  direction = "INGRESS"

  source_ranges = ["${var.vpn_remote_cidr_block}"]
}

resource "google_compute_firewall" "allow-web" {
  name    = "${var.google_network}-allow-web"
  network = "${google_compute_network.default.name}"

  allow {
    protocol = "tcp"
    ports    = ["80", "443"]
  }

  direction = "INGRESS"

  source_ranges = ["${var.vpn_remote_cidr_block}"]
}

resource "google_compute_vpn_gateway" "target_gateway" {
  name    = "${var.google_network}-vpn"
  network = "${google_compute_network.default.self_link}"
  region  = "${var.google_region}"
}

resource "google_compute_address" "vpn_static_ip" {
  name   = "${var.google_network}-ip"
  region = "${var.google_region}"
}

resource "google_compute_forwarding_rule" "fr_esp" {
  name        = "${var.google_network}-fr-esp"
  region      = "${var.google_region}"
  ip_protocol = "ESP"
  ip_address  = "${google_compute_address.vpn_static_ip.address}"
  target      = "${google_compute_vpn_gateway.target_gateway.self_link}"
}

resource "google_compute_forwarding_rule" "fr_udp500" {
  name        = "${var.google_network}-fr-udp500"
  region      = "${var.google_region}"
  ip_protocol = "UDP"
  port_range  = "500"
  ip_address  = "${google_compute_address.vpn_static_ip.address}"
  target      = "${google_compute_vpn_gateway.target_gateway.self_link}"
}

resource "google_compute_forwarding_rule" "fr_udp4500" {
  name        = "${var.google_network}-fr-udp4500"
  region      = "${var.google_region}"
  ip_protocol = "UDP"
  port_range  = "4500"
  ip_address  = "${google_compute_address.vpn_static_ip.address}"
  target      = "${google_compute_vpn_gateway.target_gateway.self_link}"
}

resource "google_compute_vpn_tunnel" "tunnel_0" {
  name          = "${var.google_network}-tunnel-0"
  region        = "${var.google_region}"
  peer_ip       = "${var.vpn_tunnel_ip_0}"
  ike_version   = "${var.vpn_ike_version}"
  shared_secret = "${var.vpn_tunnel_pre_shared_key_0}"

  target_vpn_gateway = "${google_compute_vpn_gateway.target_gateway.self_link}"

  local_traffic_selector = ["${google_compute_subnetwork.default.ip_cidr_range}"]

  depends_on = [
    "google_compute_forwarding_rule.fr_esp",
    "google_compute_forwarding_rule.fr_udp500",
    "google_compute_forwarding_rule.fr_udp4500",
  ]
}

resource "google_compute_vpn_tunnel" "tunnel_1" {
  name          = "${var.google_network}-tunnel-1"
  region        = "${var.google_region}"
  peer_ip       = "${var.vpn_tunnel_ip_1}"
  ike_version   = "${var.vpn_ike_version}"
  shared_secret = "${var.vpn_tunnel_pre_shared_key_1}"

  target_vpn_gateway = "${google_compute_vpn_gateway.target_gateway.self_link}"

  local_traffic_selector = ["${google_compute_subnetwork.default.ip_cidr_range}"]

  depends_on = [
    "google_compute_forwarding_rule.fr_esp",
    "google_compute_forwarding_rule.fr_udp500",
    "google_compute_forwarding_rule.fr_udp4500",
  ]
}

resource "google_compute_route" "route_0" {
  name       = "${var.google_network}-tunnel-route-0"
  network    = "${google_compute_network.default.name}"
  dest_range = "${var.vpn_remote_cidr_block}"
  priority   = 1000

  next_hop_vpn_tunnel = "${google_compute_vpn_tunnel.tunnel_0.self_link}"
}

resource "google_compute_route" "route_1" {
  name       = "${var.google_network}-tunnel-route-1"
  network    = "${google_compute_network.default.name}"
  dest_range = "${var.vpn_remote_cidr_block}"
  priority   = 1000

  next_hop_vpn_tunnel = "${google_compute_vpn_tunnel.tunnel_1.self_link}"
}
