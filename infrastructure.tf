# Infrastructure related to csgo-server
## Firewalls
resource "google_compute_firewall" "csgo-server-firewall" {
  name = "csgo-server-firewall"
  description = "Allow access to the CSGo Server"
  network = "default"
  
  allow {
    protocol = "tcp"
    ports = ["27015"]
  }

  allow {
    protocol = "udp"
    ports = [
      "27015",
      "27020",
      "27005",
      "51840"
    ]
  }

  source_ranges = ["0.0.0.0/0"]
}

## CSGO Server
resource "google_compute_instance" "cgso-server" {
  name = "csgo-server"
  description = "A Small CSGo practice server"

  machine_type = "${var.csgo-instance-machine-type}"
  zone = "${var.csgo-instance-region}"

  boot_disk {
    initialize_params {
      type = "pd-standard"
      image = "ubuntu-1804-bionic-v20180426b"
      size = "20"
    }
  }

  network_interface {
    network       = "default"
    access_config {}
  }

  metadata {
    sshKeys = "${join("\n", var.csgo-instance-ssh-keys)}"
  }

  tags = [
    "csgo-server"
  ]
}