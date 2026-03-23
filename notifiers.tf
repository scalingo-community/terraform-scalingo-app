data "scalingo_notification_platform" "platforms" {
  for_each = toset([for n in var.notifiers : n.platform])

  name = each.value
}

resource "scalingo_notifier" "notifiers" {
  for_each = { for n in var.notifiers : n.name => n }

  app         = scalingo_app.app.id
  name        = each.value.name
  platform_id = data.scalingo_notification_platform.platforms[each.value.platform].id

  active          = each.value.active
  send_all_events = each.value.send_all_events
  send_all_alerts = each.value.send_all_alerts
  selected_events = each.value.selected_events
  emails          = each.value.emails
  webhook_url     = each.value.webhook_url
}

resource "scalingo_alert" "alerts" {
  for_each = { for a in var.alerts : "${a.container_type}-${a.metric}" => a }

  app            = scalingo_app.app.id
  container_type = each.value.container_type
  metric         = each.value.metric
  limit          = each.value.limit

  disabled                = each.value.disabled
  duration_before_trigger = each.value.duration_before_trigger
  remind_every            = each.value.remind_every
  send_when_below         = each.value.send_when_below

  notifiers = [
    for name in each.value.notifiers : scalingo_notifier.notifiers[name].id
  ]
}
