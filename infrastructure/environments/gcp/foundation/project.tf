data "google_organization" "airdate_org" {
  domain = "airdate.cloud"
}

data "google_billing_account" "airdate_billing_account" {
  billing_account = "016E57-9D8A13-FCB94B"
}

locals {
  enabled_apis = [
    "iamcredentials.googleapis.com",
    "cloudresourcemanager.googleapis.com",
    "cloudbilling.googleapis.com",
    "iam.googleapis.com",
    "billingbudgets.googleapis.com"
  ]
}

resource "google_project" "airdate_foundation" {
  name                = "Airdate Foundation"
  project_id          = "airdate-foundation"
  org_id              = data.google_organization.airdate_org.org_id
  billing_account     = data.google_billing_account.airdate_billing_account.id
  auto_create_network = false
  lifecycle {
    prevent_destroy = true
  }
}

resource "google_project_service" "enabled_apis" {
  for_each = toset(local.enabled_apis)
  project  = google_project.airdate_foundation.id
  service  = each.value
}