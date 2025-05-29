variable "project_name" {
  description = "Name of the project"
  type        = string
}
variable "environment" {
  description = "Environment name"
  type        = string
}
variable "vpc_id" {
  description = "ID of the VPC"
  type        = string
}
variable "private_app_subnet_ids" {
  description = "List of private application subnet IDs"
  type        = list(string)
}
variable "app_sg_id" {
  description = "Security group ID for application servers"
  type        = string
}
variable "instance_type" {
  description = "EC2 instance type"
  type        = string
  default     = "t2.micro"
}
variable "app_instance_count" {
  description = "Number of application servers to launch"
  type        = number
  default     = 2
}
variable "key_name" {
  description = "SSH key name"
  type        = string
}
