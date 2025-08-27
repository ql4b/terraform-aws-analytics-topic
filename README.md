# terraform-aws-analytics-topic

> SNS topic creation and publisher permissions for analytics event producers

This module works together with the [terraform-aws-analytics-pipeline](https://github.com/ql4b/terraform-aws-analytics-pipeline) to simplify event ingestion setup.

The module manages:
- **SNS topic creation** with proper naming conventions
- **Publisher permissions** - IAM policies granting producer roles `sns:Publish` access

*Note: The [analytics-pipeline](https://github.com/ql4b/terraform-aws-analytics-pipeline) module handles the SQS subscription to your topics.*

## Usage

### Basic Topic Creation

```hcl
module "airswitch_events" {
  source = "git::https://github.com/ql4b/terraform-aws-analytics-topic.git"
  
  context    = module.label.context
  attributes = ["airswitch", "events"]
  
  publisher_roles = [
    data.terraform_remote_state.airswitch.outputs.ryanair.consumer_role.arn
  ]
}
```

### Integration with Analytics Pipeline

```hcl
# 1. Create the topic
module "api_events" {
  source = "git::https://github.com/ql4b/terraform-aws-analytics-topic.git"
  
  context    = module.label.context
  attributes = ["api", "events"]
  
  publisher_roles = [
    "arn:aws:iam::${local.account_id}:role/cloudless-airline-*"
  ]
}

# 2. Connect to analytics pipeline
module "analytics" {
  source = "git::https://github.com/ql4b/terraform-aws-analytics-pipeline.git"
  
  context = module.label.context
  
  data_sources = [{
    type = "sns"
    arn  = module.api_events.topic_arn
  }]
}
```

### Multiple Publishers

```hcl
module "shared_events" {
  source = "git::https://github.com/ql4b/terraform-aws-analytics-topic.git"
  
  context    = module.label.context
  attributes = ["shared", "events"]
  
  publisher_roles = [
    data.terraform_remote_state.airswitch.outputs.ryanair.consumer_role.arn,
    data.terraform_remote_state.cdp_cloud.outputs.execution_role.arn,
    "arn:aws:iam::${local.account_id}:role/manual-publisher-role"
  ]
}
```

## Architecture Flow

```
Producer → SNS Topic (this module) → SQS Queue (pipeline module) → Firehose → S3/OpenSearch
```

## Outputs

- `sns_topic_arn` - SNS topic ARN for use in analytics pipeline
- `sns_topic_name` - SNS topic name