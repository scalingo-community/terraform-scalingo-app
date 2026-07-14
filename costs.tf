# Cost estimation of the resources managed by this module, based on the rates
# manually provided through the `pricing` variable (see the
# `estimated_monthly_cost` output).

locals {
  # Public rates shipped with the module (see pricing_defaults.tf, kept up to
  # date by the "Update pricing" workflow), overridable entry by entry through
  # the `pricing` variable (e.g. negotiated rates).
  effective_pricing = {
    currency        = var.pricing.currency
    container_sizes = merge(local.default_pricing.container_sizes, var.pricing.container_sizes)
    addon_plans     = merge(local.default_pricing.addon_plans, var.pricing.addon_plans)
  }

  # When an autoscaler is configured, the amount of running containers varies
  # between min_containers and max_containers: the cost is estimated as a
  # range. Otherwise min and max are both the configured amount.
  _container_pricing_inputs = {
    for name, container in var.containers : name => {
      size       = container.size
      unit_price = try(local.effective_pricing.container_sizes[container.size], null)
      amount     = container.autoscaler != null ? container.autoscaler.min_containers : container.amount
      amount_max = container.autoscaler != null ? container.autoscaler.max_containers : container.amount
    }
  }

  container_costs = {
    for name, c in local._container_pricing_inputs : name => merge(c, {
      monthly_cost     = c.unit_price != null ? c.unit_price * c.amount : null
      monthly_cost_max = c.unit_price != null ? c.unit_price * c.amount_max : null
    })
  }

  addon_costs = {
    for provider, addon in { for a in var.addons : a.provider => a } : provider => {
      plan         = addon.plan
      monthly_cost = try(local.effective_pricing.addon_plans[addon.plan], null)
    }
  }

  # Sizes and plans in use but missing from the pricing maps: their cost is
  # unknown, so they are excluded from the totals and reported to the user.
  unpriced_container_sizes = distinct([
    for name, cost in local.container_costs : cost.size if cost.unit_price == null
  ])
  unpriced_addon_plans = distinct([
    for provider, cost in local.addon_costs : cost.plan if cost.monthly_cost == null
  ])

  # Totals are rounded to 2 decimals to avoid floating point noise.
  estimated_monthly_cost = floor(sum(concat(
    [0],
    [for cost in local.container_costs : cost.monthly_cost if cost.monthly_cost != null],
    [for cost in local.addon_costs : cost.monthly_cost if cost.monthly_cost != null]
  )) * 100 + 0.5) / 100

  estimated_monthly_cost_max = floor(sum(concat(
    [0],
    [for cost in local.container_costs : cost.monthly_cost_max if cost.monthly_cost_max != null],
    [for cost in local.addon_costs : cost.monthly_cost if cost.monthly_cost != null]
  )) * 100 + 0.5) / 100
}
