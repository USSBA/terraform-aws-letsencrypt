terraform {
  required_version = "~> 0.12"
  required_providers {
    aws     = "~> 2.22"
    archive = "~> 1.2"
  }
}

data "aws_region" "current" {}

locals {
  region = data.aws_region.current.name
}
