terraform {
  cloud {
    organization = "airdate"

    workspaces {
      name = "gcp-organisation-structure"
    }
  }
}