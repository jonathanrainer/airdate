terraform {
  backend "gcs" {
    bucket = "airdate-foundation-state"
    prefix = "terraform-cloud"
  }
}