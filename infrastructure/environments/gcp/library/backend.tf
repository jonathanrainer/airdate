terraform {
  cloud {
    organization = "airdate"

    workspaces {
      name = "library"
    }
  }
}