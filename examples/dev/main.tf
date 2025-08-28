terraform {
  required_version = ">= 1.6.0"
}

provider "aws" { region = var.region }

# Mock deps for local plan
locals {
  vpc_id             = "vpc-123456"
  private_subnet_ids = ["subnet-abc123", "subnet-def456"]
  app_sg_id          = "sg-123456"
}

module "redis" {
  source = "../.."

  project_prefix = var.project_prefix

  # Legacy names
  vpc_id             = local.vpc_id
  private_subnet_ids = local.private_subnet_ids
  app_sg_id          = local.app_sg_id

  # New names (same values)
  redis_vpc_id       = local.vpc_id
  subnet_ids         = local.private_subnet_ids
  allowed_from_sg_id = local.app_sg_id
}
