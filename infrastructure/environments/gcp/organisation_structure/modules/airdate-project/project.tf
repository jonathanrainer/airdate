data "google_organization" "airdate_org" {
  domain = "airdate.cloud"
}

data "google_billing_account" "airdate_billing_account" {
  billing_account = "016E57-9D8A13-FCB94B"
}

resource "google_project" "airdate_foundation" {
  name                = var.project_name
  project_id          = var.project_id
  org_id              = data.google_organization.airdate_org.org_id
  billing_account     = data.google_billing_account.airdate_billing_account.id
  auto_create_network = false
}