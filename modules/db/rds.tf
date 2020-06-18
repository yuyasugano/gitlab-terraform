resource "aws_security_group" "rds-sg" {
  name = var.rds_sg_name
  vpc_id = var.vpc_id

  ingress {
    from_port = 5432
    to_port = 5432
    protocol = "tcp"
    security_groups = [var.elb_sg_id]
  }

  egress {
    from_port = 0
    to_port   = 0
    protocol  = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

resource "aws_db_subnet_group" "default" {
  name = var.rds_group_name
  subnet_ids = [var.vpc_private_a_id, var.vpc_private_c_id]
}

resource "aws_db_instance" "default" {
  allocated_storage = 100
  storage_type = "io1"
  storage_encrypted = false
  engine = "postgresql"
  instance_class = "db.m4.large"
  multi_az = true
  iops = "1000"
  username = var.db_username
  password = var.db_password
  db_subnet_group_name = aws_db_subnet_group.default.name
  vpc_security_group_ids = [aws_security_group.rds-sg.id]
}

