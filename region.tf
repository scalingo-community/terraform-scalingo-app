data "scalingo_region" "current" {
}

locals {
  current_region = data.scalingo_region.current.name
}
