data "google_iam_role" "workload_identity_user" {
  name = "roles/iam.workloadIdentityUser"
}

data "google_project" "project" {}

resource "google_iam_workload_identity_pool" "github_actions" {
  workload_identity_pool_id = "github-actions"
  display_name              = "GitHub Actons"
  description               = "Identity pool to authenticate GitHub Actions from the `airdate` repo"
}

resource "google_iam_workload_identity_pool_provider" "github_actions" {
  workload_identity_pool_id          = google_iam_workload_identity_pool.github_actions.workload_identity_pool_id
  workload_identity_pool_provider_id = "github-actions"
  display_name                       = "GitHub Actions"
  description                        = "Identity pool provider for GitHub Actions to allow pushing to GAR"
  oidc {
    issuer_uri = "https://token.actions.githubusercontent.com"
  }
  attribute_mapping = {
    "google.subject" : "assertion.sub"
    "attribute.actor" : "assertion.actor"
    "attribute.repository" : "assertion.repository"
    "attribute.repository_owner" : "assertion.repository_owner"
  }
  attribute_condition = "assertion.repository_owner == 'jonathanrainer' && assertion.repository == 'airdate'"
}

resource "google_service_account_iam_binding" "github_actions_workload_identity_user" {
  members = [
    "principalSet://iam.googleapis.com/projects/${data.google_project.project.number}/locations/global/workloadIdentityPools/${google_iam_workload_identity_pool.github_actions.workload_identity_pool_id}/attribute.repository/jonathanrainer/airdate"
  ]
  role               = data.google_iam_role.workload_identity_user.name
  service_account_id = google_service_account.frontdoor_artifact_repository_writer.id
}