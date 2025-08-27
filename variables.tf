variable "enabled" {
    type = bool
    description = "Set to false to prevent the module from creating any resources"
    default = true
}

variable "pipeline_sqs_queue_arn" {
    type = string
    description = "the ARN of the SQS queue you want to subscrive to the SNS topic"
}

variable "event_producer_role_arn" {
    type = string
    description = "The ARN of the role you want to grant sns:Publish to "
}

