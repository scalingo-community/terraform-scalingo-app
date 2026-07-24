# Tests for an application running outside the default region.
#
# Every assertion of outputs.tftest.hcl uses osc-fr1, which is also the default
# of the region variable: those tests would pass even if the variable never
# reached the outputs. Here the mocked application runs in osc-secnum-fr1, so
# the region variable is the only thing that can produce the expected values.

mock_provider "scalingo" {
  mock_data "scalingo_stack" {
    defaults = {
      id = "stack-default"
    }
  }

  mock_data "scalingo_region" {
    defaults = {
      id           = "region-osc-secnum-fr1"
      api          = "https://api.osc-secnum-fr1.scalingo.com"
      dashboard    = "https://dashboard.scalingo.com"
      database_api = "https://db-api.osc-secnum-fr1.scalingo.com"
      display_name = "France (SecNumCloud)"
      ssh          = "ssh.osc-secnum-fr1.scalingo.com"
    }
  }

  mock_resource "scalingo_app" {
    defaults = {
      id       = "app-test"
      name     = "test-app"
      url      = "https://test-app.osc-secnum-fr1.scalingo.io"
      base_url = "https://test-app.osc-secnum-fr1.scalingo.io"
      git_url  = "git@ssh.osc-secnum-fr1.scalingo.com:test-app.git"
    }
  }
}

run "outputs_follow_the_region_variable" {
  variables {
    name   = "test-app"
    region = "osc-secnum-fr1"
  }

  assert {
    condition     = output.region == "osc-secnum-fr1"
    error_message = "The region output must follow the region variable, not its default."
  }

  assert {
    condition     = output.origin_domain == "test-app.osc-secnum-fr1.scalingo.io"
    error_message = "The origin_domain output must be built with the configured region."
  }
}

# Reproduces the v0.5.0 upgrade: the region used to come from the
# SCALINGO_REGION environment variable, so an application running outside
# osc-fr1 ends up with the default region variable and wrong outputs. The check
# block of upgrade_to_v0.6.0.tf must report it.
run "region_left_to_its_default_is_reported" {
  variables {
    name = "test-app"
  }

  expect_failures = [check.region_matches_application]
}
