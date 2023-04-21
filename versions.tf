terraform {
  required_version = ">= 1.3.9, < 2.0.0"

  required_providers {
    scalingo = {
      source  = "scalingo/scalingo"
      version = "~> 2.0"
    }

    environment = {
      source  = "eppo/environment"
      version = "~> 1.3"
    }
  }
}
