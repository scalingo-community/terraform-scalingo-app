data "scalingo_region" "current" {
  name = var.region
}

locals {
  current_region = data.scalingo_region.current.name
}
