#############################################
## Description: tf file to create MSSQL DB ##
#############################################


#Configure AWS Defaults
provider "aws" {
        access_key      = "${var.secret_access_key}"
        secret_key      = "${var.secret_key}"
        region          = "${var.region}"

}


#creating a subnet for AZ eu-west-1a
resource "aws_subnet" "mssql-db-subnet-1" {
	vpc_id		= "${var.vpc_id}"
	cidr_block	= "${var.cidr_range_az_1}"
	availability_zone = "eu-west-1a"
	tags {
		Name	= "mssql-subnet-1"
	}
}


#creating a subnet for AZ eu-west-1b
resource "aws_subnet" "mssql-db-subnet-2" {
     vpc_id          = "${var.vpc_id}"
     cidr_block      = "${var.cidr_range_az_2}"
     availability_zone = "eu-west-1b"
     tags {
         Name    = "mssql-subnet-2"
    }
}



#creating a subnet group for the above subnets
resource "aws_db_subnet_group" "mssql-db-subnet-group-ice" {
	name 		= "mssql-db-subnet-groupg-ice"
	subnet_ids      = ["${aws_subnet.mssql-db-subnet-1.id}", "${aws_subnet.mssql-db-subnet-2.id}"]
	tags {
		Name	= "mssql-db-subnet-group"
	}
}


#creating a security group to allow access to the DB
resource "aws_security_group" "mssql_rds_security_group" {
  name = "mssql_security_group"
  description = "SG to allow connection to MSSQL DB"
  vpc_id = "${var.vpc_id}"

  ingress {
    from_port = 1433
    to_port   = 1433
    protocol  = "tcp"
    cidr_blocks = ["${var.cidr_range_security_group}"]	
}
    tags {
	Name = "mssql_security_group" 
}
}


#creating parameter group to force SSL connection
resource "aws_db_parameter_group" "mssql_ssl" {
  name   = "database"
  family = "sqlserver-se-13.0"
 
  parameter {
    name         = "rds.force_ssl"
    value        = "1"
    apply_method = "pending-reboot"
  }
}



#building the Microsoft SQL Server
resource "aws_db_instance" "mssql_db" {
	allocated_storage    = "${var.allocated_storage}"
	storage_type         = "${var.storage_type}"
	engine               = "${var.engine}"
	engine_version       = "${var.engine_version}"
	instance_class       = "${var.instance_class}"
	username             = "${var.username}"
	password             = "${var.password}"
	publicly_accessible  = "false"
	storage_encrypted    = "true" 
	parameter_group_name = "${aws_db_parameter_group.mssql_ssl.name}"
	auto_minor_version_upgrade = "${var.auto_minor_version_upgrade}"
	db_subnet_group_name = "${aws_db_subnet_group.mssql-db-subnet-group-ice.id}"
	license_model	     = "license-included"
	multi_az	     = "true"
	maintenance_window   = "${var.maintenance_window}"
	backup_window	     = "${var.backup_window}"
	skip_final_snapshot  = "${var.skip_final_snapshot}"
	apply_immediately    = "${var.apply_immediately}"
	backup_retention_period = "${var.backup_retention_period}"
	kms_key_id 	     = "${var.kms_arn}"
	vpc_security_group_ids = ["${aws_security_group.mssql_rds_security_group.id}"]


	tags { 
		Name = "MSSQL-DB"
	}
}
