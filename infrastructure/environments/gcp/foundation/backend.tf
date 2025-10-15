terraform {
  backend "gcs" {
    bucket = "airdate-foundation-state"
    prefix = "state"
  }
}