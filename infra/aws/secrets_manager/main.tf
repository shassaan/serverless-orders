resource "aws_secretsmanager_secret" "aws_secrets" {
  name_prefix = var.secret_name
}

resource "aws_secretsmanager_secret_version" "this" {
  secret_id     = aws_secretsmanager_secret.aws_secrets.id
  secret_string = var.secret_value
}