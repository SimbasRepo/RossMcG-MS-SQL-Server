##################
## outputs file ##
##################

# Output the ID of the RDS instance
output "rds_instance_id" {
  value = "${aws_db_instance.mssql_db.id}"
}

# Output the address (aka hostname) of the RDS instance
output "rds_instance_address" {
  value = "${aws_db_instance.mssql_db.address}"
}

# Output endpoint (hostname:port) of the RDS instance
output "rds_instance_endpoint" {
  value = "${aws_db_instance.mssql_db.endpoint}"
}

