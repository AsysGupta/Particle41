provider "aws" {
  region = var.aws_region

}

terraform {
  backend "s3" {}
}


module "alb" {
  source = "../modules/alb"

  lb_name                    = var.lb_name
  internal                   = var.internal
  security_groups            = var.security_groups
  subnets                    = var.subnets
  enable_deletion_protection = var.enable_deletion_protection

  vpc_id            = var.vpc_id
  target_group_name = var.target_group_name
  target_port       = var.target_port
  target_protocol   = var.target_protocol
  target_type       = var.target_type
  health_check_path = var.health_check_path
  listener_port     = var.listener_port
  listener_protocol = var.listener_protocol
}
