terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 4.0"
    }
  }
  required_version = ">= 1.0"
}

provider "aws" {
  region = var.aws_region
  default_tags {
    tags = {
      Project     = "Three-Tier-Architecture"
      Environment = var.environment
      ManagedBy   = "Terraform"
    }
  }
}

