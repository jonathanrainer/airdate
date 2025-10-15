locals {
  workspaces = [
    "gcp-organisation-structure",
  ]
}

module "terraform_cloud_workspaces" {
  source   = "./modules/airdate-workspace"
  for_each = toset(local.workspaces)

  organization_name                 = tfe_organization.pmqs_cloud.name
  workspace_name                    = each.value
  workload_identity_variable_set_id = tfe_variable_set.gcp_workload_identity_federation.id
}