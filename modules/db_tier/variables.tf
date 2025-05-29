variable "project_name" {
  description = "Name of the project"
  type        = string
}
variable "environment" {
  description = "Environment name"
  type        = string
}
variable "private_db_subnet_ids" {
  description = "List of private database subnet IDs"
  type        = list(string)
}
variable "db_sg_id" {
  description = "Security group ID for database"
  type        = string
}
variable "db_instance_class" {
  description = "Database instance class"
  type        = string
  default     = "db.t3.micro"
}
variable "db_name" {
  description = "Name of the database"
  type        = string
  default     = "appdb"
}
variable "db_username" {
  description = "Database master username"
  type        = string
  default     = "admin"
  sensitive   = true
}
variable "db_password" {
  description = "Database master password"
  type        = string
  sensitive   = true
}
