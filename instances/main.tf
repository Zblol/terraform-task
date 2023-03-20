## CREATE CONTROL PLANE INSTANCE
resource "google_compute_instance" "talos_controlplane_1" {
  name         = "talos-controlplane-1"
  machine_type = "n1-standard-2"
  zone         = var.zone

  boot_disk {
    initialize_params {
      size  = 20
      image = local.talos-image
    }
  }

  network_interface {
    network    = local.talos-network
    subnetwork = local.talos-subnetwork
    access_config {
      nat_ip = local.control_plane_1_ip
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


## CREATE WORKER INSTANCE
resource "google_compute_instance" "talos_worker_1" {
  name         = "talos-worker-1"
  machine_type = "n1-standard-2"
  zone         = var.zone
  tags         = ["talos-worker-1"]

  boot_disk {
    initialize_params {
      image = local.talos-image
      size  = 20
    }
  }

  network_interface {
    network    = local.network
    subnetwork = local.subnet
    access_config {
      nat_ip = worker_node_1_ip
    }
  }

}
