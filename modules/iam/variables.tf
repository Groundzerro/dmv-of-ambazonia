variable "project_name" {
  type = string
}

variable "dynamodb_table_arn" {
  type = string
}

variable "aws_region" {
  type = string
}

variable "account_id" {
  type = string
}

variable "function_name" {
  type = string
}

variable "lambda_depends_on" {
  type        = any
  description = "Passed from root to force permission after lambda exists"
}
