data "aws_caller_identity" "current" {}

locals {
  tags = {
    Project     = var.project_name
    Environment = var.environment
  }
}

module "dynamodb_config" {
  source     = "./modules/dynamodb-config"
  table_name = "${var.project_name}-${var.environment}-config"
  tags       = local.tags
}

module "iam" {
  source             = "./modules/iam"
  project_name       = var.project_name
  dynamodb_table_arn = module.dynamodb_config.table_arn
  aws_region         = var.aws_region
  account_id         = data.aws_caller_identity.current.account_id

  # instance_id            = var.connect_instance_id
  function_name     = module.lambda_config_loader.function_name
  lambda_depends_on = [module.lambda_config_loader]
}

# Lambda function
module "lambda_config_loader" {
  source              = "./modules/lambda-config-loader"
  function_name       = "${var.project_name}-${var.environment}-config-loader"
  role_arn            = module.iam.lambda_exec_role_arn
  dynamodb_table_name = module.dynamodb_config.table_name
  environment         = var.environment
  project_name        = var.project_name
}

# Allow Connect to invoke the Lambda (using real Lambda ARN)
resource "aws_lambda_permission" "allow_connect_invoke" {
  statement_id  = "AllowExecutionFromAmazonConnect"
  action        = "lambda:InvokeFunction"
  function_name = module.lambda_config_loader.function_name
  principal     = "connect.amazonaws.com"
  source_arn    = "arn:aws:connect:${var.aws_region}:${data.aws_caller_identity.current.account_id}:instance/${var.connect_instance_id}"
}

module "connect_core" {
  source         = "./modules/connect-core"
  instance_id    = var.connect_instance_id
  project_name   = var.project_name
  lambda_arn     = module.lambda_config_loader.lambda_arn
  phone_number   = "+14694566764"
  hours_timezone = "America/Los_Angeles"
}
