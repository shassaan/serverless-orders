resource "aws_db_instance" "this" {
  allocated_storage    = 20
  engine               = "postgres"
  instance_class       = "db.t3.micro"
  db_name              = "test_db"
  identifier           = var.name
  username             = var.username
  password             = var.password
  publicly_accessible  = var.publicly_accessible
  db_subnet_group_name = aws_db_subnet_group.this.name
  skip_final_snapshot  = true
}


resource "aws_db_subnet_group" "this" {
  name        = "order-db-subnet-group"
  description = "Database subnet group for RDS instance"
  subnet_ids  = var.subnets
}