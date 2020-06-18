resource "aws_security_group" "elb-sg" {
  name = var.elb-sg_name
  vpc_id = var.vpc_id
}

resource "aws_security_group_rule" "inbound_http" {
  type = "ingress"
  from_port = 80
  to_port = 80
  protocol = "tcp"
  cidr_blocks = ["0.0.0.0/0"]

  security_group_id = aws_security_group.elb-sg.id
}

resource "aws_security_group_rule" "inbound_https" {
  type = "ingress"
  from_port = 443
  to_port = 443
  protocol = "tcp"
  cidr_blocks = ["0.0.0.0/0"]

  security_group_id = aws_security_group.elb-sg.id
}

resource "aws_security_group_rule" "outbout_rule" {
  type = "egress"
  from_port = 0
  to_port   = 0
  protocol  = "-1"
  cidr_blocks = ["0.0.0.0/0"]

  security_group_id = aws_security_group.elb-sg.id
}

resource "aws_elb" "gitlab" {
  name = var.elb_name
  availability_zones = ["ap-northeast-1a", "ap-northeast-1c"]
  security_groups = [aws_security_group.elb-sg.id]

  listener {
    instance_port = 80
    instance_protocol = "http"
    lb_port = 80
    lb_protocol = "http"
  }

  listener {
    instance_port = 80
    instance_protocol = "http"
    lb_port = 443
    lb_protocol = "https"
    ssl_certificate_id = var.certificate_arn
  }

  health_check {
    healthy_threshold = 2
    unhealthy_threshold = 2
    timeout = 3
    target = "HTTP:80/"
    interval = 30
  }

  cross_zone_load_balancing = true
  idle_timeout = 120
  connection_draining = true
  connection_draining_timeout = 120
}
