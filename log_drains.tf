# Log drains
# How it works :https://doc.scalingo.com/platform/app/log-drain
# API Docs : https://developers.scalingo.com/log_drains
resource "scalingo_log_drain" "log_drain" {
  for_each = { for log_drain in var.log_drains : log_drain.type => log_drain }

  app = scalingo_app.app.id

  type = each.value.type
  url  = sensitive(each.value.url)
}
