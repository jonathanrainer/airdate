data "google_iam_role" "artifact_registry_reader" {
  name = "roles/artifactregistry.createOnPushWriter"
}

resource "google_artifact_registry_repository" "frontdoor_repo" {
  location      = "us-central1"
  repository_id = "frontdoor"
  description   = "Image repository for the Frontdoor Service Docker Images"
  format        = "DOCKER"

  docker_config {
    immutable_tags = true
  }
}

resource "google_service_account" "frontdoor_artifact_repository_writer" {
  account_id = "frontdoor-artifact-repo-writer"
}

resource "google_artifact_registry_repository_iam_binding" "writer" {
  members = [
    google_service_account.frontdoor_artifact_repository_writer.member
  ]
  repository = google_artifact_registry_repository.frontdoor_repo.name
  role       = data.google_iam_role.artifact_registry_reader.name
}