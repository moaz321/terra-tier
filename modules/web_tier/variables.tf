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
variable "public_subnet_ids" {
  description = "List of public subnet IDs"
  type        = list(string)
}
variable "web_sg_id" {
  description = "Security group ID for web servers"
  type        = string
}
variable "instance_type" {
  description = "EC2 instance type"
  type        = string
  default     = "t2.micro"
}
variable "web_instance_count" {
  description = "Number of web servers to launch"
  type        = number
  default     = 2
}
variable "key_name" {
  description = "SSH key name"
  type        = string
}
