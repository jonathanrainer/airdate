data "google_organization" "airdate_org" {
  domain = "airdate.cloud"
}

data "google_billing_account" "airdate_billing_account" {
  billing_account = "016E57-9D8A13-FCB94B"
}

locals {
  enabled_apis = []
}

resource "google_project" "frontdoor" {
  name                = "Frontdoor"
  project_id          = "airdate-frontdoor"
  org_id              = data.google_organization.airdate_org.org_id
  billing_account     = data.google_billing_account.airdate_billing_account.id
  auto_create_network = false
}

resource "google_project_service" "enabled_apis" {
  for_each = toset(local.enabled_apis)
  project  = google_project.frontdoor
  service  = each.value
}