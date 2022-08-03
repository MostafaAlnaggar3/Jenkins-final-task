# This code will create rds instance in the default subent if you don`t have default vpc please create subnet group first
resource "aws_db_instance" "mysql-instance" {
  identifier                  = "mysqldb"
  allocated_storage           = 10
  engine                      = "mysql"
  engine_version              = "8.0.28"
  instance_class              = "db.t3.micro"
  db_name                     = "mydb"
  username                    = "admin"
  password                    = var.dbpassword
  skip_final_snapshot         = true
  availability_zone           = "${var.region}a"
  allow_major_version_upgrade = true
  db_subnet_group_name        = aws_db_subnet_group.mysql-subnet-group.name
  security_group_names        = [aws_security_group.sg-1.name]
}

resource "aws_db_subnet_group" "mysql-subnet-group" {
  name       = "mysql-subnet-group"
  subnet_ids = ["${module.Network.private_subnet_1_id}", "${module.Network.private_subnet_2_id}"]
}

