terraform {
  required_version = "~> 0.13.0"
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = ">= 2.22, < 4.0.0"
    }
    archive = {
      source  = "hashicorp/archive"
      version = "~> 1.2"
    }
  }
}

data "aws_region" "current" {}

locals {
  region = data.aws_region.current.name
}
