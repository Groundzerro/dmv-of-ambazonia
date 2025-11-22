data "archive_file" "lambda_zip" {
  type        = "zip"
  source_dir  = "${path.module}/src"
  output_path = "${path.module}/lambda_package.zip"
}

resource "aws_lambda_function" "config_loader" {
  function_name = var.function_name
  role          = var.role_arn
  handler       = "handler.lambda_handler"
  runtime       = var.runtime

  # Use the archive_file data source output instead of a hard-coded path
  filename         = data.archive_file.lambda_zip.output_path
  source_code_hash = data.archive_file.lambda_zip.output_base64sha256

  environment {
    variables = {
      TABLE_NAME   = var.dynamodb_table_name
      ENVIRONMENT  = var.environment
      PROJECT_NAME = var.project_name
    }
  }

  timeout = 10
}



# resource "aws_lambda_function" "config_loader" {
#   function_name = var.function_name
#   role          = var.role_arn
#   handler       = "handler.lambda_handler"
#   runtime       = var.runtime

#   filename         = "${path.module}/lambda_package.zip"
#   source_code_hash = filebase64sha256("${path.module}/lambda_package.zip")

#   environment {
#     variables = {
#       TABLE_NAME   = var.dynamodb_table_name
#       ENVIRONMENT  = var.environment
#       PROJECT_NAME = var.project_name
#     }
#   }

#   timeout = 10
# }

# Package the lambda code
# data "archive_file" "lambda_zip" {
#   type        = "zip"
#   source_dir  = "${path.module}/src"
#   output_path = "${path.module}/lambda_package.zip"
# }
