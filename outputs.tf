output "google_network" {
  value = "${google_compute_network.default.name}"
}

output "google_subnetwork" {
  value = "${google_compute_subnetwork.default.name}"
}

output "google_vpn_ip" {
  value = "${google_compute_address.vpn_static_ip.address}"
}

output "google_cidr_block" {
  value = "${google_compute_subnetwork.default.ip_cidr_range}"
}
