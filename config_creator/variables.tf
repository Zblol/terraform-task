
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
  description = "The region to host the cluster in"
  default = ""
}

data "google_compute_instance" "talos_controlplane_1" {
  name = "talos-controlplane-1"
  zone = var.zone
}

data "google_compute_instance" "talos_worker_1" {
  name = "talos-worker-1"
  zone = var.zone
}

data "google_compute_global_forwarding_rule" "talos_fwd_rule" {
  name = "talos-fwd-rule"
}

locals {
  control_plane_1_ip = "${data.google_compute_instance.talos_controlplane_1.network_interface[0].access_config[0].nat_ip}"
  worker_node_1_ip = "${data.google_compute_instance.talos_worker_1.network_interface[0].access_config[0].nat_ip}"
  load_balance_ip = "${data.google_compute_global_forwarding_rule.talos_fwd_rule.ip_address}"
}