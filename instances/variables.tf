
variable "project" {
  description = "The project ID to host the cluster in"
  default     = ""
}

variable "region" {
  description = "The region to host the cluster in"
  default     = "us-central1"
}

variable "zone" {
  description = "The zone to host the cluster in"
  default     = "us-central1-a"
}

variable "cred_path" {
  description = "path to credentials"
  default     = ""
}

data "google_compute_image" "talos" {
  name = "talos-amd64"
}

data "google_compute_network" "talos_network" {
  name = "talos-network"
}

data "google_compute_subnetwork" "talos_subnet" {
  name = "talos-subnet"
}

data "google_compute_address" "talos_controlplane_1_ip" {
  name = "talos-controlplane-1-ip"
}

data "google_compute_address" "talos_worker_1_ip" {
  name = "talos-worker-1-ip"
}


locals {
  talos-image        = data.google_compute_image.talos.self_link
  talos-network      = data.google_compute_network.talos_network.self_link
  talos-subnetwork   = data.google_compute_subnetwork.talos_subnet.self_link
  control_plane_1_ip = data.google_compute_instance.talos_controlplane_1.address
  worker_node_1_ip   = data.google_compute_instance.talos_worker_1.address
}
