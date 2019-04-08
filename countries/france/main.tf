provider "aws" {
  version = "~> 2.2.0"
  region  = "${var.aws_region}"
}

# Networking

locals {
  vpc_cidr_block            = "10.33.0.0/16"
}

module "networking" {
  source             = "../../infrastructure/networking"
  organization       = "${var.organization}"
  vpc_cidr_block     = "${local.vpc_cidr_block}"
}

# Brands

module "brand_one" {
  source                        = "brand-one"
  aws_region                    = "${var.aws_region}"
  ec2_key_name                  = "${var.ec2_key_name}"
  elasticbeanstalk_ec2_role     = "${var.elasticbeanstalk_ec2_role}"
  elasticbeanstalk_service_role = "${var.elasticbeanstalk_service_role}"
  organization                  = "${var.organization}"
  public_subnet_ids             = "${module.networking.public_subnet_ids}"
  vpc_id                        = "${module.networking.vpc_id}"
}
