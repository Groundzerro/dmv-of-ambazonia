terraform {
  required_version = ">= 1.5.0"

  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.0"
    }
  }

  # OPTIONAL: remote backend later (S3 + DynamoDB).
  backend "local" {}
}

provider "aws" {
  region = var.aws_region
}
