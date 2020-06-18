resource "aws_vpc" "gitlab" {
  cidr_block = var.vpc_cidr
  instance_tenancy = "default"
  enable_dns_hostnames = true
  enable_dns_support = true
  tags = {
    Name = var.vpc_name
  }
}

resource "aws_subnet" "gitlab-public-a" {
  vpc_id = aws_vpc.gitlab.id
  cidr_block = var.vpc_public_a
  map_public_ip_on_launch = true
  availability_zone = "ap-northeast-1a"
}

resource "aws_subnet" "gitlab-public-c" {
  vpc_id = aws_vpc.gitlab.id
  cidr_block = var.vpc_public_c
  map_public_ip_on_launch = true
  availability_zone = "ap-northeast-1c"
}

resource "aws_subnet" "gitlab-private-a" {
  vpc_id = aws_vpc.gitlab.id
  cidr_block = var.vpc_private_a
  map_public_ip_on_launch = false
  availability_zone = "ap-northeast-1a"
}

resource "aws_subnet" "gitlab-private-c" {
  vpc_id = aws_vpc.gitlab.id
  cidr_block = var.vpc_private_c
  map_public_ip_on_launch = false
  availability_zone = "ap-northeast-1c"
}

resource "aws_internet_gateway" "gw" {
  vpc_id = aws_vpc.gitlab.id
  tags = {
    Name = var.vpc_name
  }
}

resource "aws_route_table" "default" {
  vpc_id = aws_vpc.gitlab.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.gw.id
  }
}

resource "aws_route_table_association" "public-a" {
  subnet_id = aws_subnet.gitlab-public-a.id
  route_table_id = aws_route_table.default.id
}

resource "aws_route_table_association" "public-c" {
  subnet_id = aws_subnet.gitlab-public-c.id
  route_table_id = aws_route_table.default.id
}

