### Migration from v0.5.0 of the module
### REMOVE when releasing v1.0.0
###
### Up to v0.5.0 the region was read from the SCALINGO_REGION environment
### variable, through the eppo/environment provider. That provider is gone: the
### region now comes from the `region` variable, which defaults to "osc-fr1".
###
### Applications running in another region must set it explicitly, otherwise
### the `region` and `origin_domain` outputs silently describe the wrong
### region. The application URL embeds its actual region, so we compare the two
### and warn on any mismatch.

check "region_matches_application" {
  assert {
    condition     = can(regex("\\.${var.region}\\.scalingo\\.io", scalingo_app.app.base_url))
    error_message = "The `region` variable is set to \"${var.region}\" but the application actually runs elsewhere (${scalingo_app.app.base_url}). The `region` and `origin_domain` outputs are wrong until you set `region` to the region configured on your Scalingo provider."
  }
}
