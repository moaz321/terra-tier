provider "aws" {
  region = var.region
}

# Backend configuration for remote state (uncomment and configure as needed)
# terraform {
#   backend "s3" {
#     bucket         = "your-terraform-state-bucket"
#     key            = "three-tier/terraform.tfstate"
#     region         = "us-east-1"
#     dynamodb_table = "terraform-state-lock"
#     encrypt        = true
#   }
# }

# VPC Module
module "vpc" {
  source             = "./modules/vpc"
  vpc_cidr           = var.vpc_cidr
  availability_zones = var.availability_zones
  project_name       = var.project_name
  environment        = var.environment
}

# Security Groups Module
module "security_groups" {
  source       = "./modules/security"
  vpc_id       = module.vpc.vpc_id
  project_name = var.project_name
  environment  = var.environment
  vpc_cidr     = var.vpc_cidr
}

# Web Tier Module
module "web_tier" {
  source             = "./modules/web_tier"
  project_name       = var.project_name
  environment        = var.environment
  vpc_id             = module.vpc.vpc_id
  public_subnet_ids  = module.vpc.public_subnet_ids
  web_sg_id          = module.security_groups.web_sg_id
  instance_type      = var.instance_type
  web_instance_count = var.web_instance_count
  key_name           = var.key_name
}

# Application Tier Module
module "app_tier" {
  source                = "./modules/app_tier"
  project_name          = var.project_name
  environment           = var.environment
  vpc_id                = module.vpc.vpc_id
  private_app_subnet_ids = module.vpc.private_app_subnet_ids
  app_sg_id             = module.security_groups.app_sg_id
  instance_type         = var.instance_type
  app_instance_count    = var.app_instance_count
  key_name              = var.key_name
}

# Database Tier Module
module "db_tier" {
  source               = "./modules/db_tier"
  project_name         = var.project_name
  environment          = var.environment
  private_db_subnet_ids = module.vpc.private_db_subnet_ids
  db_sg_id             = module.security_groups.db_sg_id
  db_instance_class    = var.db_instance_class
  db_name              = var.db_name
  db_username          = var.db_username
  db_password          = var.db_password
}
