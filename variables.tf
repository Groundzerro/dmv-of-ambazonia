variable "aws_region" {
  type        = string
  description = "AWS region"
  default     = "us-west-2"
}

variable "environment" {
  type        = string
  description = "Environment name (dev, prod, etc.)"
  default     = "dev"
}

variable "project_name" {
  type        = string
  description = "Project name prefix"
  default     = "ambazonia-dmv-connect"
}

# Existing Connect instance ID (you already have one)
variable "connect_instance_id" {
  type        = string
  description = "Existing Amazon Connect instance ID (UUID)"
}
