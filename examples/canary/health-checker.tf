resource "heroku_app" "health" {
  name             = "${var.heroku_private_space}-health"
  internal_routing = true
  space            = "${heroku_space.default.name}"

  organization = {
    name = "${var.heroku_enterprise_team}"
  }

  region = "${var.heroku_private_space_region}"
}

resource "heroku_slug" "health" {
  app                            = "${heroku_app.health.name}"
  buildpack_provided_description = "Node.js"
  commit_description             = "manual slug build v4"
  file_path                      = "${var.health_app_slug_file_path}"

  process_types = {
    web = "npm start"
  }
}

resource "heroku_app_release" "health" {
  app     = "${heroku_app.health.name}"
  slug_id = "${heroku_slug.health.id}"
}

resource "heroku_formation" "health" {
  app        = "${heroku_app.health.name}"
  type       = "web"
  quantity   = "1"
  size       = "Private-S"
  depends_on = ["heroku_app_release.health"]
}

resource "google_compute_instance" "health" {
  name         = "${var.heroku_private_space}-health"
  machine_type = "g1-small"
  zone         = "${var.google_compute_zone}"

  tags = ["http-server"]

  boot_disk {
    initialize_params {
      image = "debian-cloud/debian-9"
    }
  }

  network_interface {
    subnetwork = "${var.google_subnetwork}"

    access_config {
      // This creates an ephemeral public IP
    }
  }

  metadata {
    HEALTH_CHECKER_PEER_URL = "http://${heroku_app.health.name}.herokuapp.com"
  }

  metadata_startup_script = "${file("bin/provision-gce-node-app")}"

  service_account {
    scopes = ["userinfo-email", "cloud-platform"]
  }

  provisioner "local-exec" {
    command = "./bin/health-check http://${google_compute_instance.health.network_interface.0.access_config.0.nat_ip}:8080"
  }
}

resource "google_compute_firewall" "health" {
  name        = "${var.heroku_private_space}-health"
  network     = "${var.google_network}"
  target_tags = ["http-server"]

  # allow {
  #   protocol = "tcp"
  #   ports    = ["22"]
  # }

  allow {
    protocol = "tcp"
    ports    = ["8080"]
  }

  source_ranges = ["0.0.0.0/0"]
}
