locals {
  workspaces = [
    {
      name: "gcp-organisation-structure",
      vcs_integration: true
      working_directory: "infrastructure/environments/gcp/organisation_structure"
    },
    {
      name: "frontdoor",
      vcs_integration: true
      working_directory: "infrastructure/environments/gcp/frontdoor"
    }
  ]
}

module "terraform_cloud_workspaces" {
  source   = "./modules/airdate-workspace"
  for_each = {
    for index, workspace in local.workspaces:
    workspace.name => workspace
  }

  organization_name                 = tfe_organization.pmqs_cloud.name
  workspace_name                    = each.value.name
  workload_identity_variable_set_id = tfe_variable_set.gcp_workload_identity_federation.id
  vcs_integration = each.value.vcs_integration
  working_directory = each.value.working_directory
}