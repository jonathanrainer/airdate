provider "google" {
  project               = "frontdoor"
  region                = "us-central1"
  zone                  = "us-central1-c"
  billing_project       = "frontdoor"
  user_project_override = true
}

