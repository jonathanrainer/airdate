data "google_organization" "airdate" {
  domain = "airdate.cloud"
}

resource "google_folder" "services" {
  display_name = "Services"
  parent = data.google_organization.airdate.id
}