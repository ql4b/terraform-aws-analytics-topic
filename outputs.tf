output "sns_topic_arn" {
    value = { 
        sns_topic_arn = module.sns_topic.sns_topic_arn
        sns_topic_name = module.sns_topic.sns_topic_name
    }

}