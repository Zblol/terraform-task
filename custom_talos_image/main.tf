
resource "random_id" "backet" {
  byte_length = 8
}

resource "google_storage_bucket" "storage-images" {
  name                        = "storage-images-${random_id.backet.hex}"
  project                     = var.project
  location                    = var.region
  uniform_bucket_level_access = true

  versioning {
    enabled = true
  }
}

resource "google_storage_bucket_object" "talos_image" {
  name   = "talos-gcp-amd64.tar.gz"
  source = "gcp-amd64.tar.gz"
  bucket = google_storage_bucket.storage-images.name
}

resource "google_compute_image" "talos" {
  name        = "talos-amd64"
  project     = var.project
  description = "Talos v1.3.5"
  family      = "talos-amd64"

  raw_disk {
    source = google_storage_bucket_object.talos_image.self_link
  }

  depends_on = [google_storage_bucket_object.talos_image]
}