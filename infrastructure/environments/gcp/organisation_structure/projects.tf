locals {
  projects = [
    {
      name : "airdate-frontdoor"
      display_name : "Frontdoor Service"
      parent_folder : google_folder.services.id
      enabled_apis : [
        "artifactregistry.googleapis.com"
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
}