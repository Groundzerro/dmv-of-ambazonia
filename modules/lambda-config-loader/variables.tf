variable "function_name" {
  type        = string
  description = "Lambda function name"
}

variable "runtime" {
  type    = string
  default = "python3.11"
}

variable "role_arn" {
  type        = string
  description = "IAM role ARN for the Lambda"
}

variable "dynamodb_table_name" {
  type = string
}

variable "environment" {
  type    = string
  default = "dev"
}

variable "project_name" {
  type = string
}
