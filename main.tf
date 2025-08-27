locals {
  id                       = module.this.id
  context                  = module.this.context
  enabled                  = var.enabled
  
  event_producer_role_arn  = var.event_producer_role_arn
}

module sns_topic {
    source      = "cloudposse/sns-topic/aws"
    version     = "1.2.0"

    count       = local.enabled ? 1 : 0 
    context     = module.this.context

    allowed_iam_arns_for_sns_publish = [
        local.event_producer_role_arn
    ]
}