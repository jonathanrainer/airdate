resource "tfe_workspace" "workspace" {
  name                  = var.workspace_name
  organization          = var.organization_name
  working_directory     = var.working_directory
  file_triggers_enabled = false
  auto_apply            = true
  dynamic "vcs_repo" {
    for_each = var.vcs_integration ? [{}] : []
    content {
      identifier                 = "jonathanrainer/airdate"
      branch                     = "main"
      github_app_installation_id = "ghain-LBfvqR9WHhE8quWk"
      ingress_submodules         = false
    }
  }
}