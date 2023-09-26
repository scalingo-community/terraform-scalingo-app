# Log drains
# How it works :https://doc.scalingo.com/platform/app/log-drain
# API Docs : https://developers.scalingo.com/log_drains

# Log drains for applications
resource "scalingo_log_drain" "app" {
  for_each = { for log_drain in var.log_drains : log_drain.type => log_drain }

  app = scalingo_app.app.id

  type = each.value.type

  # Log drain parameters are different depending on the type
  url          = sensitive(each.value.url)
  drain_region = each.value.drain_region
  host         = each.value.host
  port         = each.value.port
  token        = sensitive(each.value.token)
}

# Log drains for addons
resource "scalingo_log_drain" "addons" {
  # Create a map of log_drain for each addon and log_drain combination :
  # e.g. { "redis-elk" = { addon_id = "xxxx", type = "elk", url = "https://elk.example.com/xxxx" } }
  for_each = { for log_drain in setproduct(var.log_drains, values(scalingo_addon.addons)) :
    "${log_drain[1].provider_id}-${log_drain[0].type}"
    => merge(log_drain[0], { addon_id = log_drain[1].id })
  }

  # Associate the log drain to app AND addon
  app   = scalingo_app.app.id
  addon = each.value.addon_id

  type = each.value.type

  # Log drain parameters are different depending on the type
  url          = sensitive(each.value.url)
  drain_region = each.value.drain_region
  host         = each.value.host
  port         = each.value.port
  token        = sensitive(each.value.token)
}
