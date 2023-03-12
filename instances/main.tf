
data "google_compute_image" "talos" {
  name = "talos-amd64"
}

### NETWORK ###

resource "google_compute_network" "talos_network" {
  project                 = var.project
  name                    = "talos-network"
  auto_create_subnetworks = false
}


resource "google_compute_subnetwork" "talos_subnet" {
  name          = "talos-subnet"
  network       = google_compute_network.talos_network.self_link
  ip_cidr_range = "10.0.0.0/24"
  region = var.region
}


resource "google_compute_firewall" "talos_firewall_internal" {
  name    = "talos-firewall-internal"
  network = google_compute_network.talos_network.self_link

  allow {
    protocol = "tcp"
    ports    = ["22", "6443", "2379-2380", "10250-10252", "30000-32767"]
  }

  source_ranges = ["0.0.0.0/0"]
}

resource "google_compute_firewall" "talos_firewall_external" {
  name    = "talos-firewall-external"
  network = google_compute_network.talos_network.self_link

  allow {
    protocol = "tcp"
    ports    = ["22", "6443", "2379-2380", "10250-10252", "30000-32767", "80-8888"]
  }

  source_ranges = ["0.0.0.0/0"]
}


### CONTROL PLANE INSTANCE ###

resource "google_compute_address" "control_plane_ip" {
  name = "control-plane-ip"
  region = var.region
}

resource "google_compute_instance" "control_plane" {
  name         = "control-plane"
  machine_type = "n1-standard-2"
  zone         = var.zone
  tags         = ["talos"]
  boot_disk {
    initialize_params {
      image = "${data.google_compute_image.talos.self_link}"
    }
  }

  network_interface {
    network = google_compute_network.talos_network.self_link
    subnetwork = google_compute_subnetwork.talos_subnet.self_link
    access_config {
      nat_ip = google_compute_address.control_plane_ip.address
    }
  }

  metadata = {
    "startup-script" = templatefile("../template/control-panel.sh.tpl", {
      CONTROL_PLANE_IP = google_compute_address.control_plane_ip.address
      TALOSCONFIG = "_out/talosconfig"
    })
  }
}

### WORKER NODE INSTANCE ###

resource "google_compute_address" "worker_node_ip" {
  name = "worker-node-ip"
  region = var.region
}

resource "google_compute_instance" "worker_node" {
  name         = "worker-node"
  machine_type = "n1-standard-2"
  zone         = var.zone
  tags         = ["talos"]
  boot_disk {
    initialize_params {
      image = "${data.google_compute_image.talos.self_link}"
    }
  }

  network_interface {
    network = google_compute_network.talos_network.self_link
    subnetwork = google_compute_subnetwork.talos_subnet.self_link
    access_config {
      nat_ip = google_compute_address.worker_node_ip.address
    }
  }

  metadata = {
    "startup-script" = templatefile("../template/worker-node.sh.tpl", {
      CONTROL_PLANE_IP = google_compute_address.worker_node_ip.address
      TALOSCONFIG = "_out/talosconfig"
    })
  }
}
