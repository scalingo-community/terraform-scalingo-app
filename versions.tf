terraform {
  required_version = ">= 1.3.0, < 2.0.0"

  required_providers {
    scalingo = {
      source  = "scalingo/scalingo"
      version = "~> 2.7"
    }
  }
}
