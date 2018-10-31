output "health_public_url" {
  value = "http://${google_compute_instance.health.network_interface.0.access_config.0.nat_ip}:8080"
}

output "health_internal_url" {
  value = "http://${google_compute_instance.health.network_interface.0.network_ip}:8080"
}

output "health_peer_internal_url" {
  value = "https://${heroku_app.health.name}.herokuapp.com"
}
