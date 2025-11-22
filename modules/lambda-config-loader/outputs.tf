output "lambda_arn" {
  value = aws_lambda_function.config_loader.arn
}

output "lambda_name" {
  value = aws_lambda_function.config_loader.function_name
}
