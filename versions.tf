terraform {
  required_version = ">= 1.3.0, < 2.0.0"

  required_providers {
    scalingo = {
      source  = "scalingo/scalingo"
      version = "~> 2.2"
    }

    environment = {
      source  = "eppo/environment"
      version = "~> 1.3"
    }
  }
}
