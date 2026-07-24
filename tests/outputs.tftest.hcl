# Non-regression tests for the module outputs, focused on the region wiring
# (region, origin_domain, url, domain).
#
# Providers are mocked (terraform >= 1.7): no Scalingo account or API token
# is needed, resources are created in-memory only.

mock_provider "scalingo" {
  mock_data "scalingo_stack" {
    defaults = {
      id = "stack-default"
    }
  }

  mock_data "scalingo_region" {
    defaults = {
      id           = "region-osc-fr1"
      api          = "https://api.osc-fr1.scalingo.com"
      dashboard    = "https://dashboard.scalingo.com"
      database_api = "https://db-api.osc-fr1.scalingo.com"
      display_name = "France (Paris)"
      ssh          = "ssh.osc-fr1.scalingo.com"
    }
  }

  mock_resource "scalingo_app" {
    defaults = {
      id       = "app-test"
      name     = "test-app"
      url      = "https://test-app.osc-fr1.scalingo.io"
      base_url = "https://test-app.osc-fr1.scalingo.io"
      git_url  = "git@ssh.osc-fr1.scalingo.com:test-app.git"
    }
  }
}

run "outputs_without_canonical_domain" {
  variables {
    name   = "test-app"
    region = "osc-fr1"
  }

  assert {
    condition     = output.region == "osc-fr1"
    error_message = "The region output must reflect the current Scalingo region."
  }

  assert {
    condition     = output.origin_domain == "test-app.osc-fr1.scalingo.io"
    error_message = "The origin_domain output must be <name>.<region>.scalingo.io."
  }

  assert {
    condition     = output.url == "https://test-app.osc-fr1.scalingo.io"
    error_message = "Without a canonical domain, the url output must be the default app URL."
  }

  assert {
    condition     = output.domain == "test-app.osc-fr1.scalingo.io"
    error_message = "Without a canonical domain, the domain output must be the default app hostname."
  }
}

run "outputs_in_another_region" {
  variables {
    name   = "test-app"
    region = "osc-secnum-fr1"
  }

  assert {
    condition     = output.region == "osc-secnum-fr1"
    error_message = "The region output must follow the region variable, not the default."
  }

  assert {
    condition     = output.origin_domain == "test-app.osc-secnum-fr1.scalingo.io"
    error_message = "The origin_domain output must be built with the configured region."
  }
}

run "outputs_with_canonical_domain" {
  variables {
    name   = "test-app"
    region = "osc-fr1"
    domain = "www.example.com"
  }

  assert {
    condition     = output.region == "osc-fr1"
    error_message = "The region output must reflect the current Scalingo region."
  }

  assert {
    condition     = output.origin_domain == "test-app.osc-fr1.scalingo.io"
    error_message = "The origin_domain output must stay <name>.<region>.scalingo.io even with a canonical domain."
  }

  assert {
    condition     = output.url == "https://www.example.com"
    error_message = "With a canonical domain, the url output must use it."
  }

  assert {
    condition     = output.domain == "www.example.com"
    error_message = "With a canonical domain, the domain output must be that domain."
  }
}
