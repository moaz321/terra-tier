output "db_instance_endpoint" {
  description = "Connection endpoint for the database"
  value       = aws_db_instance.main.endpoint
}
output "db_instance_address" {
  description = "DNS address of the database instance"
  value       = aws_db_instance.main.address
}
output "db_instance_name" {
  description = "Name of the database"
  value       = aws_db_instance.main.db_name
}
