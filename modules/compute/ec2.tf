resource "aws_security_group" "ec2-sg" {
  name = var.ec2_sg_name
  vpc_id = var.vpc_id
}

resource "aws_security_group_rule" "inbound_ec2_ssh" {
  type = "ingress"
  from_port = 22
  to_port = 22
  protocol = "tcp"
  cidr_blocks = ["0.0.0.0/0"]

  security_group_id = aws_security_group.ec2-sg.id
}

resource "aws_security_group_rule" "inbound_ec2_http" {
  type = "ingress"
  from_port = 80
  to_port = 80
  protocol = "tcp"
  cidr_blocks = ["0.0.0.0/0"]

  security_group_id = aws_security_group.ec2-sg.id
}

resource "aws_security_group_rule" "inbound_ec2_https" {
  type = "ingress"
  from_port = 443
  to_port = 443
  protocol = "tcp"
  cidr_blocks = ["0.0.0.0/0"]

  security_group_id = aws_security_group.ec2-sg.id
}

resource "aws_security_group_rule" "outbout_ec2_rule" {
  type = "egress"
  from_port = 0
  to_port   = 0
  protocol  = "-1"
  cidr_blocks = ["0.0.0.0/0"]

  security_group_id = aws_security_group.ec2-sg.id
}

resource "aws_instance" "gitlab-a" {
  ami = "ami-0278fe6949f6b1a06"
  vpc_security_group_ids = [aws_security_group.ec2-sg.id]
  instance_type = "c5.2xlarge"
  subnet_id = var.vpc_public_a_id
}

resource "aws_instance" "gitlab-c" {
  ami = "ami-0278fe6949f6b1a06"
  vpc_security_group_ids = [aws_security_group.ec2-sg.id]
  instance_type = "c5.2xlarge"
  subnet_id = var.vpc_public_c_id
}

resource "aws_instance" "gitaly" {
  ami = "ami-0278fe6949f6b1a06"
  vpc_security_group_ids = [aws_security_group.ec2-sg.id]
  instance_type = "c5.xlarge"
  subnet_id = var.vpc_public_a_id
}

resource "aws_instance" "runner" {
  ami = "ami-0278fe6949f6b1a06"
  vpc_security_group_ids = [aws_security_group.ec2-sg.id]
  instance_type = "t2.micro"
  subnet_id = var.vpc_public_a_id
}


