
output "app_id" {
  description = "ID of the Scalingo application."
  value       = scalingo_app.app.id
}

output "all_environment_variables" {
  description = "All environment variables of the Scalingo application (ones added by the terraform module and ones added by Scalingo add-ons)."
  value       = scalingo_app.app.all_environment
  sensitive   = true # Environment variables can contain sensitive information
}

output "url" {
  description = "Base URL to access the application (`https://*`). If you have set a canonical domain, this will be the URL with the canonical domain, otherwise it will be the default URL of the Scalingo application."
  value       = (var.domain != null ? "https://${var.domain}" : scalingo_app.app.url)
}

output "domain" {
  description = "Hostname to use to access the application. Same as the `url` output but without the `https://`."
  value       = trimprefix((var.domain != null ? "https://${var.domain}" : scalingo_app.app.url), "https://")
}

output "base_url" {
  description = "Default URL of the Scalingo application (without canonical domain override)."
  value       = scalingo_app.app.base_url
}

output "origin_domain" {
  description = "The FQDN of the Scalingo application (`<your_app_name>.<region>.scalingo.io`). Same as the `domain` output if you have not set a canonical domain."
  value       = "${scalingo_app.app.name}.${local.current_region}.scalingo.io"
}

output "git_url" {
  description = "Hostname to use to deploy code with Git + SSH."
  value       = scalingo_app.app.git_url
}

output "estimated_monthly_cost" {
  description = "Estimated monthly cost of the resources managed by this module, computed from the rates manually provided in `var.pricing`. `total` uses the configured amount of containers (or `min_containers` when an autoscaler is set) while `total_max` uses `max_containers`. Resources whose size or plan is missing from `var.pricing` are excluded from the totals and listed in `unpriced`."
  value = {
    currency   = var.pricing.currency
    total      = local.estimated_monthly_cost
    total_max  = local.estimated_monthly_cost_max
    containers = local.container_costs
    addons     = local.addon_costs
    unpriced = {
      container_sizes = local.unpriced_container_sizes
      addon_plans     = local.unpriced_addon_plans
    }
  }
}

output "region" {
  description = "Region where the application is deployed."
  value       = local.current_region
}
