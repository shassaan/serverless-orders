resource "aws_msk_cluster" "orders_process_kafka_cluster" {
  cluster_name           = var.cluster_name
  kafka_version          = var.ver
  number_of_broker_nodes = var.broker_nodes
  configuration_info {
    arn      = aws_msk_configuration.this.arn
    revision = 1
  }
  broker_node_group_info {
    instance_type  = var.instance_type
    client_subnets = var.client_subnets
    storage_info {
      ebs_storage_info {
        volume_size = var.ebs_volume_size
      }
    }
    security_groups = var.security_groups
  }
}

resource "aws_msk_configuration" "this" {
  kafka_versions = [var.ver]
  name           = "config"
  server_properties = <<PROPERTIES
auto.create.topics.enable = true
delete.topic.enable = true
PROPERTIES
}