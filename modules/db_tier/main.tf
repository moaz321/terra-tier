# Create DB subnet group
resource "aws_db_subnet_group" "main" {
  name       = "${var.project_name}-${var.environment}-db-subnet-group"
  subnet_ids = var.private_db_subnet_ids
  tags = {
    Name = "${var.project_name}-${var.environment}-db-subnet-group"
  }
}
# Create DB parameter group
resource "aws_db_parameter_group" "main" {
  name   = "${var.project_name}-${var.environment}-db-parameter-group"
  family = "mysql8.0"
  parameter {
    name  = "character_set_server"
    value = "utf8mb4"
  }
  parameter {
    name  = "character_set_client"
    value = "utf8mb4"
  }
  tags = {
    Name = "${var.project_name}-${var.environment}-db-parameter-group"
  }
}
# Create RDS instance
resource "aws_db_instance" "main" {
  identifier             = "${var.project_name}-${var.environment}-db"
  allocated_storage      = 20
  storage_type           = "gp2"
  engine                 = "mysql"
  engine_version         = "8.0"
  instance_class         = var.db_instance_class
  db_name                = var.db_name
  username               = var.db_username
  password               = var.db_password
  parameter_group_name   = aws_db_parameter_group.main.name
  db_subnet_group_name   = aws_db_subnet_group.main.name
  vpc_security_group_ids = [var.db_sg_id]
  skip_final_snapshot    = true
  multi_az               = true
  backup_retention_period = 7
  storage_encrypted       = true
  tags = {
    Name = "${var.project_name}-${var.environment}-db"
  }
}
