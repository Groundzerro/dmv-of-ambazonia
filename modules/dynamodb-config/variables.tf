variable "table_name" {
  type        = string
  description = "DynamoDB table name for DMV Connect config"
}

variable "tags" {
  type    = map(string)
  default = {}
}

