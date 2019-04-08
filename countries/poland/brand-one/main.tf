# Application

module "client_panel_application" {
  source                        = "../../../infrastructure/api/application"
  name                          = "Poland | Brand One"
  elasticbeanstalk_service_role = "${var.elasticbeanstalk_service_role}"
}

# Environments

module "dev" {
  source                    = "./dev"
  organization              = "${var.organization}"
  ec2_key_name              = "${var.ec2_key_name}"
  application_name          = "${module.client_panel_application.name}"
  vpc_id                    = "${var.vpc_id}"
  public_subnet_ids         = "${var.public_subnet_ids}"
  region                    = "${var.aws_region}"
  elasticbeanstalk_ec2_role = "${var.elasticbeanstalk_ec2_role}"
}

module "uat" {
  source                    = "./uat"
  organization              = "${var.organization}"
  ec2_key_name              = "${var.ec2_key_name}"
  application_name          = "${module.client_panel_application.name}"
  vpc_id                    = "${var.vpc_id}"
  public_subnet_ids         = "${var.public_subnet_ids}"
  region                    = "${var.aws_region}"
  elasticbeanstalk_ec2_role = "${var.elasticbeanstalk_ec2_role}"
}

module "prod" {
  source                    = "./prod"
  organization              = "${var.organization}"
  ec2_key_name              = "${var.ec2_key_name}"
  public_subnet_ids         = "${var.public_subnet_ids}"
  vpc_id                    = "${var.vpc_id}"
  application_name          = "${module.client_panel_application.name}"
  region                    = "${var.aws_region}"
  elasticbeanstalk_ec2_role = "${var.elasticbeanstalk_ec2_role}"
}
