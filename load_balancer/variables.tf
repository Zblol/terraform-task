
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
  description = "The region to host the cluster in"
  default     = ""
}

data "google_compute_health_check" "talos_tcp_group_health_check" {
  name = "talos-tcp-group-health-check"
}

data "google_compute_instance_group" "talos_controlplane_group" {
  name = "talos-controlplane-group"
  zone = var.zone
}

locals {
  talos_tcp_group_health_check = data.google_compute_health_check.talos_tcp_group_health_check.self_link
  talos_controlplane_group     = data.google_compute_instance_group.talos_controlplane_group.id
}