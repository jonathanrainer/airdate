resource "google_project_service" "enabled_apis" {
  for_each = toset(var.enabled_apis)
  project  = google_project.airdate_foundation.id
  service  = each.value
}