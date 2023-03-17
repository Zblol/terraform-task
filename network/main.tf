#CREATE NETWORK
resource "google_compute_network" "talos_network" {
  project                 = var.project
  name                    = "talos-network"
  auto_create_subnetworks = false
}


resource "google_compute_subnetwork" "talos_subnet" {
  name          = "talos-subnet"
  network       = "${google_compute_network.talos_network.self_link}"
  ip_cidr_range = "10.0.0.0/24"
  region = var.region
}

# Create firewall rule for health checks
resource "google_compute_firewall" "talos_controlplane_firewall" {
  name          = "talos-controlplane-firewall"
  network       = "${google_compute_network.talos_network.self_link}"
  source_ranges = ["130.211.0.0/22", "35.191.0.0/16", "169.254.169.254","209.85.152.0/22","209.85.204.0/22"]
  target_tags   = ["talos-controlplane"]
  allow {
    protocol = "tcp"
    ports    = ["6443"]
  }
}


# Create firewall rule to allow talosctl access
resource "google_compute_firewall" "talos_controlplane_talosctl" {
  name          = "talos-controlplane-talosctl"
  network       = "${google_compute_network.talos_network.self_link}"
  source_ranges = ["0.0.0.0/0"]
  target_tags   = ["talos-controlplane","talos-worker-1"]
  allow {
    protocol = "tcp"
    ports    = ["4240", "10250", "50000", "50001", "2379","2380","4001"]
  }

  allow {
    protocol = "udp"
    ports    = ["8472"]
  }
}

#CREATE IP FOR CONTROLPLANE AND WORKER NODE
resource "google_compute_address" "talos_controlplane_1_ip" {
  name = "talos-controlplane-1-ip"
  region = var.region
}

resource "google_compute_address" "talos_worker_1_ip" {
  name = "talos-worker-1-ip"
  region = var.region
}
