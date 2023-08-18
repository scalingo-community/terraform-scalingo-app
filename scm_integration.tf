locals {
  # Set scm_integration with : 
  #  - the content of github_integration if it is not null (+ the type = "github")
  #  - the content of gitlab_integration if it is not null (+ the type = "gitlab")
  #  - an empty map otherwise
  scm_integration = (var.github_integration != null
    ? { github = var.github_integration }
    : (var.gitlab_integration != null
      ? { gitlab = var.gitlab_integration }
      : {}
    )
  )
}

data "scalingo_scm_integration" "scm_integration" {
  for_each = local.scm_integration

  scm_type = each.key
}

resource "scalingo_scm_repo_link" "scm_repo_link" {
  for_each = local.scm_integration

  # Due to a bug in the provider, we need to use the app id instead of the app name
  # Link to the issue : https://github.com/Scalingo/terraform-provider-scalingo/issues/153
  app = scalingo_app.app.id

  source = each.value.repo_url
  auth_integration_uuid = (each.value.integration_uuid != null
    ? each.value.integration_uuid
    : data.scalingo_scm_integration.scm_integration[each.key].id
  )

  auto_deploy_enabled = each.value.auto_deploy_enabled
  branch              = each.value.branch

  # Configuration for review apps
  deploy_review_apps_enabled            = var.review_apps.enabled
  delete_on_close_enabled               = var.review_apps.delete_on_close_enabled
  hours_before_delete_on_close          = var.review_apps.hours_before_delete_on_close
  delete_stale_enabled                  = var.review_apps.delete_stale_enabled
  hours_before_delete_stale             = var.review_apps.hours_before_delete_stale
  automatic_creation_from_forks_allowed = var.review_apps.automatic_creation_from_forks_allowed

  
}
