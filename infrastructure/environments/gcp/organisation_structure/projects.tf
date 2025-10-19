locals {
  projects = [
    {
      name : "airdate-frontdoor"
      display_name : "Frontdoor"
      parent_folder : google_folder.services.id
      enabled_apis : [
        "artifactregistry.googleapis.com"
      ]
    },
    {
      name : "airdate-library"
      display_name : "Library"
      parent_folder : google_folder.services.id
      enabled_apis : [
        "firestore.googleapis.com"
      ]
    }
  ]
}

module "airdate_project" {
  source = "./modules/airdate-project"
  for_each = {
    for index, project in local.projects :
    project.name => project
  }
  enabled_apis = each.value.enabled_apis
  project_id   = each.value.name
  project_name = each.value.display_name
  folder_id    = each.value.parent_folder
}

moved {
  from = google_project.airdate_project["airdate-frontdoor"]
  to   = module.airdate_project["airdate-frontdoor"].google_project.airdate_foundation
}