locals {
  # We use the base64sha256 function to mask emails in the name of the resource in tfstate
  # This is to avoid leaking emails when executing `terraform plan` in public CI
  masked_emails = {
    for email in var.additionnal_collaborators : base64sha256(email) => email
  }
  masked_limited_emails = {
    for email in var.limited_collaborators : base64sha256(email) => email
  }
}

resource "scalingo_collaborator" "collaborators" {
  for_each = local.masked_emails

  app   = scalingo_app.app.id
  email = sensitive(each.value)
}

resource "scalingo_collaborator" "limited_collaborators" {
  for_each = local.masked_limited_emails

  app     = scalingo_app.app.id
  email   = sensitive(each.value)
  limited = true

  lifecycle {
    precondition {
      condition     = length(setintersection(toset(var.additionnal_collaborators), toset(var.limited_collaborators))) == 0
      error_message = "An email cannot be listed in both additionnal_collaborators and limited_collaborators."
    }
  }
}
