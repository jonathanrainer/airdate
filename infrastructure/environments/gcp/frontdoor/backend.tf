terraform {
  cloud {
    organization = "airdate"

    workspaces {
      name = "frontdoor"
    }
  }
}