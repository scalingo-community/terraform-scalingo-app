locals {
  # The region is exposed by the Scalingo API on the application itself, so it
  # always reflects where the app actually runs (no variable to keep in sync).
  current_region = scalingo_app.app.region
}
