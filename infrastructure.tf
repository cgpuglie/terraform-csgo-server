# Infrastructure related to csgo-server
## Startup Script
data "template_file" "csgo-server-launcher-conf" {
  template = "${file("templates/csgo-server-launcher.conf")}"

  vars {
    screen-name = "${var.screen-name}"
    user = "${var.user}"
    port = "${var.port}"
    gslt = "${var.gslt}"
    dir-steamcmd = "${var.dir-steamcmd}"
    steam-login = "${var.steam-login}"
    steam-password = "${var.steam-password}"
    steam-runscript = "${var.steam-runscript}"
    dir-root = "${var.dir-root}"
    dir-game = "${var.dir-game}"
    dir-logs = "${var.dir-logs}"
    daemon-game = "${var.daemon-game}"
    update-log = "${var.update-log}"
    update-email = "${var.update-email}"
    update-retry = "${var.update-retry}"
    api-authorization-key = "${var.api-authorization-key}"
    workshop-collection-id = "${var.workshop-collection-id}"
    workshop-start-map = "${var.workshop-start-map}"
    maxplayers = "${var.maxplayers}"
    tickrate = "${var.tickrate}"
    extraparams = "${var.extraparams}"
    param-start = "${var.param-start}"
    param-update = "${var.param-update}"
  }
}

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
    csgo-server-conf = "${data.template_file.csgo-server-launcher-conf.rendered}"
    sshKeys = "${join("\n", var.csgo-instance-ssh-keys)}"
    startup-script = "${file("./files/startup.sh")}"
  }

  tags = [
    "csgo-server"
  ]
}