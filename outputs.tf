output "google_vpn_ip" {
  value = "${google_compute_address.vpn_static_ip.address}"
}

output "google_cidr_block" {
  value = "${google_compute_subnetwork.default.ip_cidr_range}"
}
