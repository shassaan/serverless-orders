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