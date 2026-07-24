terraform {
  # 1.5.0 is required by the check block of upgrade_to_v0.6.0.tf
  required_version = ">= 1.5.0, < 2.0.0"

  required_providers {
    scalingo = {
      source  = "scalingo/scalingo"
      version = "~> 2.7"
    }
  }
}
