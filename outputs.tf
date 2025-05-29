# VPC Outputs
output "vpc_id" {
  description = "ID of the VPC"
  value       = module.vpc.vpc_id
}

output "public_subnet_ids" {
  description = "IDs of the public subnets"
  value       = module.vpc.public_subnet_ids
}

output "private_app_subnet_ids" {
  description = "IDs of the private application subnets"
  value       = module.vpc.private_app_subnet_ids
}

output "private_db_subnet_ids" {
  description = "IDs of the private database subnets"
  value       = module.vpc.private_db_subnet_ids
}

# Security Group Outputs
output "alb_security_group_id" {
  description = "ID of the ALB security group"
  value       = module.security_groups.alb_sg_id
}

output "web_security_group_id" {
  description = "ID of the web tier security group"
  value       = module.security_groups.web_sg_id
}

output "app_security_group_id" {
  description = "ID of the application tier security group"
  value       = module.security_groups.app_sg_id
}

output "db_security_group_id" {
  description = "ID of the database tier security group"
  value       = module.security_groups.db_sg_id
}

# Web Tier Outputs
output "web_alb_dns_name" {
  description = "DNS name of the web tier load balancer"
  value       = module.web_tier.web_alb_dns_name
}

output "web_asg_name" {
  description = "Name of the web tier auto scaling group"
  value       = module.web_tier.web_asg_name
}

# App Tier Outputs
output "app_alb_dns_name" {
  description = "DNS name of the application tier load balancer"
  value       = module.app_tier.app_alb_dns_name
}

output "app_asg_name" {
  description = "Name of the application tier auto scaling group"
  value       = module.app_tier.app_asg_name
}

# Database Tier Outputs
output "db_endpoint" {
  description = "Endpoint of the RDS instance"
  value       = module.db_tier.db_instance_endpoint
}

output "db_address" {
  description = "Address of the RDS instance"
  value       = module.db_tier.db_instance_address
}

output "db_name" {
  description = "Name of the database"
  value       = module.db_tier.db_instance_name
}
