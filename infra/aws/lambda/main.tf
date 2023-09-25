locals {
  services_conf_file = [for fn in fileset("../services", "*/config.yaml") : fn]
  services_conf      = [for service_cof in local.services_conf_file : yamldecode(file("../services/${service_cof}"))]
  services = { for service in local.services_conf : service.name => {
    "name" : service.name
    "version" : service.version
    "batch_size" : try(service.kafka_trigger.batch_size, null)
    "topic" : try(service.kafka_trigger.topic, null)
    "is_api" : try(service.is_api, false)
    "consumer_group_id" : try(service.kafka_trigger.consumer_group_id, null)
  } }
  services_with_kafka_trigger = { for k, service in local.services : k => service if service.topic != null }
  services_with_apis          = { for k, service in local.services : k => service if service.is_api == true }
}

output "name" {
  value = local.services_with_apis
}

resource "aws_lambda_function" "this" {
  for_each      = local.services
  description   = "Lambda function for ${each.key}"
  function_name = "${each.key}-function"
  image_uri     = "778424175012.dkr.ecr.us-east-1.amazonaws.com/orders-management-ecr:${each.value.name}-${each.value.version}"
  package_type  = "Image"
  role          = "arn:aws:iam::778424175012:role/msk-lambda-role"
  timeout       = 900 # 15 min (max)
  vpc_config {
    security_group_ids = [
      "sg-072d455c09e408e5d",
    ]
    subnet_ids = [
      "subnet-018d446df94efb583",
      "subnet-07e85a63aca846f8a",
    ]
  }
}


resource "aws_lambda_event_source_mapping" "event_source_mapping" {
  for_each                           = local.services_with_kafka_trigger
  event_source_arn                   = var.msk_cluster_arn
  function_name                      = aws_lambda_function.this[each.key].function_name
  batch_size                         = each.value.batch_size
  topics                             = [each.value.topic]
  starting_position                  = "TRIM_HORIZON"
  maximum_batching_window_in_seconds = 300
  amazon_managed_kafka_event_source_config {
    consumer_group_id = each.value.consumer_group_id
  }
}

resource "aws_lambda_function_url" "lambda_url" {
  for_each           = local.services_with_apis
  function_name      = aws_lambda_function.this[each.key].function_name
  authorization_type = "NONE"
}
