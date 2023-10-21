resource "google_compute_firewall" "allow-ssh" {
  name          = "allow-ssh"
  network       = google_compute_network.gcp-iti-network.name
  source_ranges = ["0.0.0.0/0"]
  allow {
    protocol = "tcp"
    ports    = ["22"]
  }
}
