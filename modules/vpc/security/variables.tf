variable "vpc_id" {
  type        = string
  description = "The ID of the VPC"
}

variable "project_name" {
  type        = string
  description = "Name of the project"
}

variable "environment" {
  type        = string
  description = "Environment name"
}

variable "vpc_cidr" {
  type        = string
  description = "CIDR block of the VPC"
}

