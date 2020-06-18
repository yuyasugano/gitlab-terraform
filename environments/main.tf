provider "aws" {
  access_key = var.aws_access_key
  secret_key = var.aws_secret_key
  region = var.aws_region
  version = "2.23.0"
}

terraform {
  required_version = "0.12.6"
  backend "s3" {
    bucket = "tfstate-workflow-test"
    key = "gitlab-terraform/terraform.tfstate"
    region = "ap-northeast-1"
  }
}

module "iam" {
  source = "../modules/iam"

  iam_name = var.default_iam_name
}

module "vpc" {
  source = "../modules/vpc"

  vpc_name = var.default_vpc_name
  vpc_cidr = var.default_vpc_cidr
  vpc_public_a = var.default_public_a
  vpc_public_c = var.default_public_c
  vpc_private_a = var.default_private_a
  vpc_private_c = var.default_private_c
  vpc_gw_name = var.default_gw_name
}

module "compute" {
  source = "../modules/compute"

  vpc_id = "${module.vpc.gitlab_vpc_id}"
  vpc_public_a_id = "${module.vpc.vpc_public_a_id}"
  vpc_public_c_id = "${module.vpc.vpc_public_c_id}"
  vpc_private_a_id = "${module.vpc.vpc_private_a_id}"
  vpc_private_c_id = "${module.vpc.vpc_private_c_id}"
  elb_name = var.default_elb_name
  elb-sg_name = var.default_elb_sg_name
  ec2_sg_name = var.default_ec2_sg_name
  certificate_arn = var.default_certificate_arn
}

module "rds" {
  source = "../modules/db"

  vpc_id = "${module.vpc.gitlab_vpc_id}"
  vpc_public_a_id = "${module.vpc.vpc_public_a_id}"
  vpc_public_c_id = "${module.vpc.vpc_public_c_id}"
  vpc_private_a_id = "${module.vpc.vpc_private_a_id}"
  vpc_private_c_id = "${module.vpc.vpc_private_c_id}"
  elb_sg_id = "${module.compute.elb_sg_id}" 
  rds_sg_name = var.default_rds_sg_name
  rds_group_name = var.default_rds_group_name
  db_username = var.default_db_username
  db_password = var.default_db_password
  redis_sg_name = var.default_redis_sg_name
  redis_group_name = var.default_redis_group_name
}

