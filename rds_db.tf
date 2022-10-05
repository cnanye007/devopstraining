# Create Database Subnet Group
# terraform aws db subnet group
resource "aws_db_subnet_group" "database-subnet-group" {
  name        = "rds_db_subnet_grp"
  subnet_ids  = [aws_subnet.private-subnet-3.id, aws_subnet.private-subnet-4.id]
  description = "subnet group for rds db"

  tags = {
    Name = "rds_db_subnet_grp"
  }
}

# Get the Latest DB Snapshot
# # terraform aws data db snapshot
# data "aws_db_snapshot" "latest-db-snapshot" {
#   db_snapshot_identifier = "${var.rds_snapshot_identifier}"
#   most_recent            = true
#   snapshot_type          = "manual"
# }

# Create Database Instance Restored from DB Snapshots
# terraform aws db instance
resource "aws_db_instance" "rds_db-instance" {
  instance_class      = var.rds_db_instance_class
  allocated_storage    = 10
  engine_version       = "5.7"
  engine               = "mysql"
  password             = "devopsadmin"
  username             = "devopsadmin"
  skip_final_snapshot = true
  availability_zone   = "us-east-1a"
  identifier          = var.rds_db_instance_identifier
  #snapshot_identifier     = data.aws_db_snapshot.latest-db-snapshot.id
  db_subnet_group_name   = aws_db_subnet_group.database-subnet-group.name
  multi_az               = var.rds_multi_az_deployment
  vpc_security_group_ids = [aws_security_group.database-security-group.id]
}