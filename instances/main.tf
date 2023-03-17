## CREATE CONTROL PLANE INSTANCE
resource "google_compute_instance" "talos_controlplane_1" {
  name         = "talos-controlplane-1"
  machine_type = "n1-standard-2"
  zone         = "us-central1-a"

  boot_disk {
    initialize_params {
      size = 20
      image = "${data.google_compute_image.talos.self_link}"
    }
  }

  network_interface {
    network       = "${data.google_compute_network.talos_network.self_link}"
    subnetwork = "${data.google_compute_subnetwork.talos_subnet.self_link}"
    access_config {
      nat_ip = "${data.google_compute_address.talos_controlplane_1_ip.address}"
    }
  }

  tags = ["talos-controlplane"]
}


# Create Instance Group
# Create port for IG
resource "google_compute_instance_group" "talos_controlplane_group" {
  name = "talos-controlplane-group"
  zone = var.zone
  instances = [
    google_compute_instance.talos_controlplane_1.id
  ]

  named_port {
    name = "tcpgroup"
    port = 6443
  }
}

# Create health check
resource "google_compute_health_check" "talos_tcp_group_health_check" {
  name = "talos-tcp-group-health-check"
  check_interval_sec = 5
  timeout_sec = 5
  tcp_health_check {
    port = 6443
  }
}

## CREATE WORKER INSTANCE
resource "google_compute_instance" "talos_worker_1" {
  name         = "talos-worker-1"
  machine_type = "n1-standard-2"
  zone         = var.zone
  tags         = ["talos-worker-1"]

  boot_disk {
    initialize_params {
      image = "${data.google_compute_image.talos.self_link}"
      size  = 20
    }
  }

  network_interface {
    network       = "${data.google_compute_network.talos_network.self_link}"
    subnetwork = "${data.google_compute_subnetwork.talos_subnet.self_link}"
    access_config {
      nat_ip = "${data.google_compute_address.talos_worker_1_ip.address}"
    }
  }

}   
