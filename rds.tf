# ------------------------
# rds parameter group
# ------------------------
resource "aws_db_parameter_group" "mysql_standalone_parammetergroup" {
  family = "mysql8.0"
  name   = "${var.project}-${var.environment}-mysql-standalone-param-group"

  parameter {
    name  = "character_set_database"
    value = "utf8mb4"
  }

  parameter {
    name  = "character_set_server"
    value = "utf8mb4"
  }

}

# ------------------------
# option group
# ------------------------
resource "aws_db_option_group" "mysql_standalone_opriongroup" {
  name                 = "${var.project}-${var.environment}-mysql-standalone-option-group"
  engine_name          = "mysql"
  major_engine_version = "8.0"
}

# ------------------------
# subnet group
# ------------------------
resource "aws_db_subnet_group" "mysql_standalone_subnetgroup" {
  name = "${var.project}-${var.environment}-mysql-standalone-subnet-group"
  subnet_ids = [
    aws_subnet.private_subnet_1a.id,
    aws_subnet.private_subnet_1c.id
  ]

  tags = {
    Name    = "${var.project}-${var.environment}-mysql-standalone-subnet-group"
    Project = var.project
    Env     = var.environment
  }
}
