variable "instance_id" {
  type        = string
  description = "Existing Amazon Connect instance ID"
}

variable "project_name" {
  type = string
}

variable "lambda_arn" {
  type = string
}

variable "phone_number" {
  type        = string
  description = "E.164 phone number you’ve already claimed (e.g. +12065551234)"
}

variable "hours_timezone" {
  type    = string
  default = "America/Los_Angeles"
}
