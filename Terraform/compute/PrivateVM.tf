resource "google_compute_instance" "private_vm" {
  name         = "private-vm-instance"
  machine_type = "e2-medium"
  zone         = var.zone2


  boot_disk {
    initialize_params {
      image = "debian-cloud/debian-11"
    }
  }

  network_interface {
    network    = var.network_name
    subnetwork = var.google_compute_subnet2
  }

  tags = ["iap-allow-ssh"]
}
