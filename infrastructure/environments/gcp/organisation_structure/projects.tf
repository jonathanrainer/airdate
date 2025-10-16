locals {
  projects = [
    {
      name: "frontdoor"
      display_name: "Frontdoor Service"
      parent_folder: "406737292785"
    }
  ]
}

resource "google_project" "airdate_project" {
  for_each = {
    for index, project in local.projects:
    project.name => project
  }
  name       = each.value.display_name
  project_id = each.value.name
  folder_id = each.value.parent_folder
}