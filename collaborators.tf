locals {
  # We use the base64sha256 function to mask emails in the name of the resource in tfstate
  # This is to avoid leaking emails when executing `terraform plan` in public CI
  masked_emails = {
    for email in var.additionnal_collaborators : base64sha256(email) => email
  }
}

resource "scalingo_collaborator" "collaborators" {
  for_each = local.masked_emails

  app   = scalingo_app.app.id
  email = sensitive(each.value)
}
