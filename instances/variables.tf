
variable "project" {
  description = "The project ID to host the cluster in"
  default = ""
}

variable "region" {
  description = "The region to host the cluster in"
  default = "us-central1"
}

variable "zone" {
  description = "The zone to host the cluster in"
  default = "us-central1-a"
}

variable "cred_path" {
  description = "path to credentials"
  default = ""
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

