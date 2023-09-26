### Migration from v0.2.0 of the module
### REMOVE when releasing v1.0.0

moved {
  from = scalingo_log_drain.log_drain["elk"]
  to   = scalingo_log_drain.app["elk"]
}
moved {
  from = scalingo_log_drain.log_drain["appsignal"]
  to   = scalingo_log_drain.app["appsignal"]
}
moved {
  from = scalingo_log_drain.log_drain["logtail"]
  to   = scalingo_log_drain.app["logtail"]
}
moved {
  from = scalingo_log_drain.log_drain["datadog"]
  to   = scalingo_log_drain.app["datadog"]
}
moved {
  from = scalingo_log_drain.log_drain["ovh-graylog"]
  to   = scalingo_log_drain.app["ovh-graylog"]
}
moved {
  from = scalingo_log_drain.log_drain["papertrail"]
  to   = scalingo_log_drain.app["papertrail"]
}
moved {
  from = scalingo_log_drain.log_drain["logtail"]
  to   = scalingo_log_drain.app["logtail"]
}
moved {
  from = scalingo_log_drain.log_drain["syslog"]
  to   = scalingo_log_drain.app["syslog"]
}
