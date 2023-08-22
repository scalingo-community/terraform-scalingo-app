# Terraform Module for Scalingo App 

An opinionated Terraform module to provision an application and database very easily with Scalingo

<!-- BEGIN_TF_DOCS -->
## Requirements

| Name | Version |
|------|---------|
| <a name="requirement_terraform"></a> [terraform](#requirement\_terraform) | >= 1.3.0, < 2.0.0 |
| <a name="requirement_environment"></a> [environment](#requirement\_environment) | ~> 1.3 |
| <a name="requirement_scalingo"></a> [scalingo](#requirement\_scalingo) | ~> 2.2 |

## Resources

| Name | Type |
|------|------|
| [scalingo_addon.addons](https://registry.terraform.io/providers/scalingo/scalingo/latest/docs/resources/addon) | resource |
| [scalingo_app.app](https://registry.terraform.io/providers/scalingo/scalingo/latest/docs/resources/app) | resource |
| [scalingo_autoscaler.autoscalers](https://registry.terraform.io/providers/scalingo/scalingo/latest/docs/resources/autoscaler) | resource |
| [scalingo_collaborator.collaborators](https://registry.terraform.io/providers/scalingo/scalingo/latest/docs/resources/collaborator) | resource |
| [scalingo_container_type.containers](https://registry.terraform.io/providers/scalingo/scalingo/latest/docs/resources/container_type) | resource |
| [scalingo_domain.canonical_domain](https://registry.terraform.io/providers/scalingo/scalingo/latest/docs/resources/domain) | resource |
| [scalingo_domain.domain_aliases](https://registry.terraform.io/providers/scalingo/scalingo/latest/docs/resources/domain) | resource |
| [scalingo_log_drain.log_drain](https://registry.terraform.io/providers/scalingo/scalingo/latest/docs/resources/log_drain) | resource |
| [scalingo_scm_repo_link.scm_repo_link](https://registry.terraform.io/providers/scalingo/scalingo/latest/docs/resources/scm_repo_link) | resource |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_additionnal_collaborators"></a> [additionnal\_collaborators](#input\_additionnal\_collaborators) | List of emails of collaborators that have admin rights for the application | `list(string)` | `[]` | no |
| <a name="input_addons"></a> [addons](#input\_addons) | List of addons to add to the application | <pre>list(object({<br>    provider          = string<br>    plan              = string<br>    database_features = optional(list(string))<br>  }))</pre> | `[]` | no |
| <a name="input_authorize_unsecure_http"></a> [authorize\_unsecure\_http](#input\_authorize\_unsecure\_http) | When true, Scalingo does not automatically redirect HTTP traffic to HTTPS. The default behavior is to redirect HTTP traffic to HTTPS (when value is `false`) | `bool` | `false` | no |
| <a name="input_containers"></a> [containers](#input\_containers) | Configuration of the containers of the application. | <pre>map(object({<br>    size   = optional(string, "S")<br>    amount = optional(number, 1)<br>    autoscaler = optional(object({<br>      min_containers = optional(number, 2)<br>      max_containers = optional(number, 10)<br>      metric         = optional(string, "cpu")<br>      target         = optional(number, 0.8)<br>    }))<br>  }))</pre> | <pre>{<br>  "web": {<br>    "amount": 0,<br>    "size": "S"<br>  }<br>}</pre> | no |
| <a name="input_domain"></a> [domain](#input\_domain) | Main domain name of the application, known as "canonical domain" in Scalingo's dashboard. Note that SSL configuration must be completed through the dashboard. | `string` | `null` | no |
| <a name="input_domain_aliases"></a> [domain\_aliases](#input\_domain\_aliases) | List of others domain names for the application | `list(string)` | `[]` | no |
| <a name="input_environment"></a> [environment](#input\_environment) | Map of environment variables to set on the application. Note that value of environment variables can be null or empty. | `map(string)` | `null` | no |
| <a name="input_github_integration"></a> [github\_integration](#input\_github\_integration) | Configuration of the GitHub integration of the application. Only one of github\_integration or gitlab\_integration can be set. | <pre>object({<br>    repo_url            = string<br>    integration_uuid    = optional(string)<br>    branch              = optional(string, "main")<br>    auto_deploy_enabled = optional(bool, true)<br>  })</pre> | `null` | no |
| <a name="input_gitlab_integration"></a> [gitlab\_integration](#input\_gitlab\_integration) | Configuration of the GitLab integration of the application. Only one of github\_integration or gitlab\_integration can be set. | <pre>object({<br>    repo_url            = string<br>    integration_uuid    = optional(string)<br>    branch              = optional(string, "main")<br>    auto_deploy_enabled = optional(bool, true)<br>  })</pre> | `null` | no |
| <a name="input_log_drains"></a> [log\_drains](#input\_log\_drains) | n/a | <pre>list(object({<br>    type = string<br>    url  = optional(string, "")<br>  }))</pre> | `[]` | no |
| <a name="input_name"></a> [name](#input\_name) | n/a | `string` | n/a | yes |
| <a name="input_review_apps"></a> [review\_apps](#input\_review\_apps) | Configuration of the review apps of the application. | <pre>object({<br>    enabled = optional(bool, false)<br><br>    # By default: delete review apps 0 hours after closing the PR<br>    delete_on_close_enabled      = optional(bool, true)<br>    hours_before_delete_on_close = optional(string, "0")<br><br>    # By default: delete review apps after 5 days of inactivity (= no new deployment)<br>    delete_stale_enabled      = optional(bool, true)<br>    hours_before_delete_stale = optional(string, "168")<br><br>    # By default: do not create review apps for PRs from forks<br>    automatic_creation_from_forks_allowed = optional(bool, false)<br>  })</pre> | `{}` | no |
| <a name="input_router_logs"></a> [router\_logs](#input\_router\_logs) | When true, the router logs are included in the application logs. (default: `false`) | `bool` | `false` | no |
| <a name="input_stack"></a> [stack](#input\_stack) | The stack to use for the app (default: "scalingo-22"). | `string` | `"scalingo-22"` | no |
| <a name="input_sticky_session"></a> [sticky\_session](#input\_sticky\_session) | When true, sticky sessions are enabled. (default: `false`) | `bool` | `false` | no |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_all_environment_variables"></a> [all\_environment\_variables](#output\_all\_environment\_variables) | All environment variables of the Scalingo application (ones added by the terraform module and ones added by Scalingo add-ons). |
| <a name="output_app_id"></a> [app\_id](#output\_app\_id) | ID of the Scalingo application. |
| <a name="output_domain"></a> [domain](#output\_domain) | Hostname to use to access the application. Same as the `url` output but without the `https://`. |
| <a name="output_git_url"></a> [git\_url](#output\_git\_url) | Hostname to use to deploy code with Git + SSH. |
| <a name="output_origin_domain"></a> [origin\_domain](#output\_origin\_domain) | The FQDN of the Scalingo application (`<your_app_name>.<region>.scalingo.io`). Same as the `domain` output if you have not set a canonical domain. |
| <a name="output_region"></a> [region](#output\_region) | Region where the application is deployed. |
| <a name="output_url"></a> [url](#output\_url) | Base URL to access the application (`https://*`). If you have set a canonical domain, this will be the URL with the canonical domain, otherwise it will be the default URL of the Scalingo application. |
<!-- END_TF_DOCS -->

## Generate documentation

This module use `terraform-docs` to auto-generate its documentation. You can use it without installing it thanks to this `docker` command :

```
docker run --rm -v "$(pwd):/terraform-docs" -u $(id -u) quay.io/terraform-docs/terraform-docs:0.16.0 markdown table /terraform-docs
```
