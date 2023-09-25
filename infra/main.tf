module "msk" {
  source          = "./aws/msk"
  cluster_name    = "orders-process-kafka-cluster"
  instance_type   = "kafka.m5.large"
  ver             = "2.8.1"
  ebs_volume_size = 1000
  broker_nodes    = 2
  security_groups = ["sg-072d455c09e408e5d"]
  client_subnets  = ["subnet-07e85a63aca846f8a", "subnet-018d446df94efb583"]
}

module "rds" {
  source              = "./aws/rds"
  name                = "order-processing-rds"
  username            = "dev"
  password            = "Admin123**"
  subnets             = ["subnet-07e85a63aca846f8a", "subnet-018d446df94efb583"]
  publicly_accessible = true
}

module "ecr" {
  source = "./aws/ecr"
  name   = "orders-management-ecr"
}
module "lambda" {
  source          = "./aws/lambda"
  msk_cluster_arn = "arn:aws:kafka:us-east-1:778424175012:cluster/orders-process-kafka-cluster/19b8155a-8b81-4d23-8418-4b77e23ff49a-10"
}

module "secret_manager_products" {
  source       = "./aws/secrets_manager"
  secret_name  = "db/products_info/password"
  secret_value = "Admin123**"
}

module "secret_manager_customers" {
  source       = "./aws/secrets_manager"
  secret_name  = "db/customer_orders/password"
  secret_value = "Admin123**"
}