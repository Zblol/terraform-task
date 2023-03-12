terraform {
  required_providers {
    google = {
      source  = "hashicorp/google"
      version = "~> 4.47.0"
    }
  }
}


provider "google" {
  credentials = var.cred_path
  project     = var.project
  region      = var.region
}