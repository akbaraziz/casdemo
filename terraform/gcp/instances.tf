data google_compute_zones "zones" {}

resource google_compute_instance "server" {
  machine_type = "n1-standard-1"
  name         = "casdemo-${var.environment}-machine"
  zone         = data.google_compute_zones.zones.names[0]
  boot_disk {
    initialize_params {
      image = "debian-cloud/debian-9"
    }
    auto_delete = true
  }
  network_interface {
    subnetwork = google_compute_subnetwork.public-subnetwork.name
    access_config {}
  }
  can_ip_forward = true

  metadata = {
    block-project-ssh-keys = false
    enable-oslogin         = false
    serial-port-enable     = true
  }
  labels = {
    yor_trace = "a764f1bc-0456-4deb-b3cb-faf95a1b5616"
  }
}

resource google_compute_disk "unencrypted_disk" {
  name = "casdemo-${var.environment}-disk"
  labels = {
    yor_trace = "4104d20c-f551-45e2-89a6-81f2fa541622"
  }
}