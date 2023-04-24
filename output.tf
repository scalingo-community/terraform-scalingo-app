output "url" {
  description = "Base URL to access the application (`https://*`). If you have set a canonical domain, this will be the URL with the canonical domain, otherwise it will be the default URL of the Scalingo application."
  value       = (var.canonical_domain == "" ? scalingo_app.app.url : "https://${var.canonical_domain}")
}

output "domain" {
  description = "Hostname to use to access the application. Same as the `url` output but without the `https://`."
  value       = trim(scalingo_app.app.url, "https://")
}

output "origin_domain" {
  description = "The FQDN of the Scalingo application (`<your_app_name>.<region>.scalingo.io`). Same as the url output if you have not set a canonical domain."
  value       = "${scalingo_app.app.name}.${local.current_region}.scalingo.io"
}

output "git_url" {
  description = "Hostname to use to deploy code with Git + SSH."
  value       = scalingo_app.app.git_url
}

output "region" {
  description = "Region where the application is deployed."
  value       = local.current_region
}

output "log_drain_url" {
  description = "URL of the drain to use by Scalingo to send logs to your log management system. (Note: the username and password are included in the URL, be careful with the security of this URL.). It's already marked as sensitive to avoid leaking it in the Terraform state."
  value       = sensitive(scalingo_app.log_drain.drain_url)
}
