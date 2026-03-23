resource "scalingo_domain" "canonical_domain" {
  for_each = toset(var.domain != null ? [var.domain] : [])

  app         = scalingo_app.app.id
  canonical   = true
  common_name = var.domain

  letsencrypt_enabled = var.letsencrypt
}

resource "scalingo_domain" "domain_aliases" {
  for_each = toset(var.domain_aliases)

  app         = scalingo_app.app.id
  canonical   = false
  common_name = each.key
}
