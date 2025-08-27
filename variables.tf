variable "enabled" {
    type = bool
    description = "Set to false to prevent the module from creating any resources"
    default = true
}

variable "event_producer_role_arn" {
    type = string
    description = "The ARN of the role you want to grant sns:Publish to "
}

