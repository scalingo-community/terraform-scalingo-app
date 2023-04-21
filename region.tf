data "environment_variables" "scalingo_region_env" {
  filter = "^SCALINGO_REGION"
}

locals {
  current_region = lookup(data.environment_variables.scalingo_region_env.items, "SCALINGO_REGION", null)
}
