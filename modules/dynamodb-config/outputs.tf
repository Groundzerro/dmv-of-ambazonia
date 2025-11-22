output "table_name" {
  value = aws_dynamodb_table.config.name
}

output "table_arn" {
  value = aws_dynamodb_table.config.arn
}
