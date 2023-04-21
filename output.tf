output "url" {
  description = "Base URL (https://*) to access the application"
  value       = scalingo_app.app.url
}

output "domain" {
  description = "Hostname to use to access the application (without https://)"
  value       = trim(scalingo_app.app.url, "https://")
}

output "git_url" {
  description = "Hostname to use to deploy code with Git + SSH"
  value       = scalingo_app.app.git_url
}

output "region" {
  description = "Region where the application is deployed"
  value       = local.current_region
}
