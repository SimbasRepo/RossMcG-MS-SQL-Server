###########################################
## TFVariables feeding from vars.tf file ##
###########################################

kms_arn = "arn:aws:kms:eu-west-1:###########:key#######################"

secret_access_key = "##################"

secret_key = "#########################"

region = "eu-west-1"

vpc_id = "vpc-##########"

allocated_storage = "200"

storage_type = "gp2"

engine = "sqlserver-se"

engine_version = "13.00.4422.0.v1"

instance_class = "db.m4.large"

username = "#############"

password = "#################"

auto_minor_version_upgrade = true

maintenance_window = "Sun:00:00-Sun:03:00"
 
backup_window = "03:00-05:00"

skip_final_snapshot = true
#skipped so you can terraform destroy without going onto console

apply_immediately = true

backup_retention_period = 1

cidr_range_security_group = "##########"

cidr_range_az_1 = "###########"

cidr_range_az_2 = "###########"

