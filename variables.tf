variable "name" {
  description = "Name of the application. Must be unique on Scalingo."
  type        = string
}

variable "stack" {
  description = "The stack to use for the app (default: \"scalingo-22\")."
  type        = string
  default     = "scalingo-22"

  validation {
    condition     = contains(["scalingo-18", "scalingo-20", "scalingo-22"], var.stack)
    error_message = "The stack value must be one of the following: scalingo-18, scalingo-20, scalingo-22"
  }
}

variable "containers" {
  description = "Configuration of the containers of the application."
  type = map(object({
    size   = optional(string, "S")
    amount = optional(number, 1)
    autoscaler = optional(object({
      min_containers = optional(number, 2)
      max_containers = optional(number, 10)
      metric         = optional(string, "cpu")
      target         = optional(number, 0.8)
    }))
  }))
  default  = { web = { size = "S", amount = 0 } }
  nullable = false
}

variable "authorize_unsecure_http" {
  description = "When true, Scalingo does not automatically redirect HTTP traffic to HTTPS. The default behavior is to redirect HTTP traffic to HTTPS (when value is `false`)"
  type        = bool
  default     = false
  nullable    = false
}

variable "router_logs" {
  description = "When true, the router logs are included in the application logs. (default: `false`)"
  type        = bool
  default     = false
  nullable    = false
}

variable "sticky_session" {
  description = "When true, sticky sessions are enabled. (default: `false`)"
  type        = bool
  default     = false
  nullable    = false
}

variable "github_integration" {
  description = "Configuration of the GitHub integration of the application. Only one of github_integration or gitlab_integration can be set."
  type = object({
    repo_url            = string
    integration_uuid    = optional(string)
    branch              = optional(string, "main")
    auto_deploy_enabled = optional(bool, true)
  })
  default = null
}

variable "gitlab_integration" {
  description = "Configuration of the GitLab integration of the application. Only one of github_integration or gitlab_integration can be set."
  type = object({
    repo_url            = string
    integration_uuid    = optional(string)
    branch              = optional(string, "main")
    auto_deploy_enabled = optional(bool, true)
  })
  default = null
}

variable "review_apps" {
  description = "Configuration of the review apps of the application."
  type = object({
    enabled = optional(bool, false)

    # By default: delete review apps 0 hours after closing the PR
    delete_on_close_enabled      = optional(bool, true)
    hours_before_delete_on_close = optional(string, "0")

    # By default: delete review apps after 5 days of inactivity (= no new deployment)
    delete_stale_enabled      = optional(bool, true)
    hours_before_delete_stale = optional(string, "168")

    # By default: do not create review apps for PRs from forks
    automatic_creation_from_forks_allowed = optional(bool, false)
  })
  default = {}
}

variable "additionnal_collaborators" {
  description = "List of emails of collaborators that have admin rights for the application"
  type        = list(string)
  default     = []
  nullable    = false

  # validate that the list contains only valid emails
  validation {
    condition = length([
      for email in var.additionnal_collaborators :
      email if regex("^([a-zA-Z0-9_\\-\\.]+)@([a-zA-Z0-9_\\-\\.]+)\\.([a-zA-Z]{2,5})$", email) == false
    ]) == 0
    error_message = "The list of emails must contain only valid emails."
  }
}

variable "environment" {
  description = "Map of environment variables to set on the application. Note that value of environment variables can be null or empty."
  type        = map(string)
  default     = null

  # validate that the map does not contain any null and empty values
  validation {
    condition = length([
      for key, value in var.environment :
      key if value == null || value == ""
    ]) == 0
    error_message = "The map of environment variables must not contain any null or empty values."
  }
}

variable "addons" {
  description = "List of addons to add to the application"
  type = list(object({
    provider          = string
    plan              = string
    database_features = optional(list(string))
  }))
  default  = []
  nullable = false
}

# TODO: implement notifier and alert
#
# variable "notifications" {
#   type = list(object({
#     name            = string
#     type            = string
#     active          = optional(bool, true)
#     emails          = optional(list(string), [])
#     send_all_alerts = optional(bool, false)
#     send_all_events = optional(bool, false)
#     events          = optional(list(string), [])
#     webhook_url     = optional(string, "")
#     container_alerts = object({
#       limit                   = optional(number, 0.8)
#       metric                  = optional(string, "cpu")
#       duration_before_trigger = optional(string)
#     })
#   }))
#   default  = []
#   nullable = false
# }

variable "domain" {
  description = "Main domain name of the application, known as \"canonical domain\" in Scalingo's dashboard. Note that SSL configuration must be completed through the dashboard."
  type        = string
  default     = null
  nullable    = true

  validation {
    condition     = var.domain == null || can(length(regex("^([a-zA-Z0-9_\\-\\.]+)\\.([a-zA-Z]{2,5})$", var.domain)) > 0)
    error_message = "The domain name must be a valid domain name."
  }
}

variable "domain_aliases" {
  description = "List of others domain names for the application"
  type        = list(string)
  default     = []
  nullable    = false

  validation {
    condition = length([
      for domain in var.domain_aliases :
      domain if !can(length(regex("^([a-zA-Z0-9_\\-\\.]+)\\.([a-zA-Z]{2,6})$", domain)) == 0)
    ]) == 0
    error_message = "The list of domain names must contain only valid domain names."
  }
}

variable "log_drains" {
  description = "List of log_drain configuration to redirect logs from the application and addons to a log management service. Each configuration is automatically associated to the application and to every eligible addons."
  type = list(object({
    type         = string
    url          = optional(string, "")
    drain_region = optional(string, "")
    host         = optional(string, "")
    port         = optional(string, "")
    token        = optional(string, "")
  }))
  default  = []
  nullable = false

  validation {
    condition = length([
      for drain in var.log_drains :
      drain if !contains(["elk", "appsignal", "logtail", "datadog", "ovh-graylog", "papertrail", "logtail", "syslog"], drain.type)
    ]) == 0
    error_message = "The list of log drains must contain only valid log drains type (elk/appsignal/logtail/datadog/ovh-graylog/papertrail/logtail/syslog)."
  }

  validation {
    condition = length([
      for drain in var.log_drains :
      drain if drain.type == "elk" && can(length(regex("^https?://([a-zA-Z0-9_\\-\\.]+)\\.([a-zA-Z]{2,5})$", drain.url)) == 0)
    ]) == 0
    error_message = "Log drains of type \"elk\" must have a valid url."
  }
}
