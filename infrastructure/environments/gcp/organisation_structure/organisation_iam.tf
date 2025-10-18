data "google_iam_role" "folder_viewer" {
  name = "roles/resourcemanager.folderViewer"
}
resource "google_organization_iam_binding" "folder_viewer" {
  members = [
    "user:jonathan@airdate.cloud"
  ]
  org_id = data.google_organization.airdate.id
  role   = data.google_iam_role.folder_viewer.name
}

data "google_iam_role" "browser" {
  name = "roles/browser"
}

resource "google_organization_iam_binding" "browser" {
  members = [
    "user:jonathan@airdate.cloud"
  ]
  org_id = data.google_organization.airdate.id
  role   = data.google_iam_role.browser.name
}