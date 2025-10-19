data "google_project" "project" {}
resource "google_firestore_database" "database" {
  name                              = "library"
  location_id                       = "nam5"
  type                              = "FIRESTORE_NATIVE"
  concurrency_mode                  = "OPTIMISTIC"
  app_engine_integration_mode       = "DISABLED"
  point_in_time_recovery_enablement = "POINT_IN_TIME_RECOVERY_ENABLED"
  delete_protection_state           = "DELETE_PROTECTION_ENABLED"
}

data "google_iam_role" "datastore_user" {
  name = "roles/datastore.user"
}

resource "google_project_iam_binding" "firestore_user" {
  members = [
    "user:jonathan@airdate.cloud"
  ]
  role    = data.google_iam_role.datastore_user.name
  project = data.google_project.project.project_id
}