provider "google" {
  project = "airdate-foundation"
  region  = "us-central1"
  zone    = "us-central1-c"
}

terraform {
  required_providers {
    google = {
      source  = "hashicorp/google"
      version = "7.7.0"
    }
  }
}