locals {
  projects = [
    {
      name : "airdate-frontdoor"
      display_name : "Frontdoor Service"
      parent_folder : google_folder.services.id
    }
  ]
}

resource "google_project" "airdate_project" {
  for_each = {
    for index, project in local.projects :
    project.name => project
  }
  name       = each.value.display_name
  project_id = each.value.name
  folder_id  = each.value.parent_folder
}