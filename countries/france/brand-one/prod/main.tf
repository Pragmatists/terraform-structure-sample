locals {
  brand                    = "fr-brand-one"
  environment              = "prod"
  web_address_backoffice   = "backoffice.brand-one.example.fr"
  web_address_client_panel = "client-panel.brand-one.example.fr"
}

# API

module "api" {
  source                    = "../../../../infrastructure/api/prod"
  organization              = "${var.organization}"
  application_name          = "${var.application_name}"
  environment_name          = "fr-brand-one-prod"
  ec2_key_name              = "${var.ec2_key_name}"
  instances_max_count       = 2
  vpc_id                    = "${var.vpc_id}"
  public_subnet_ids         = "${var.public_subnet_ids}"
  region                    = "${var.region}"
  elasticbeanstalk_ec2_role = "${var.elasticbeanstalk_ec2_role}"
  backoffice_url            = "https://${local.web_address_backoffice}"
}

# Client Panel

module "client_panel" {
  source = "./client-panel"

  brand                               = "${local.brand}"
  elastic_beanstalk_environment_cname = "${module.api.elastic_beanstalk_environment_cname}"
  elastic_beanstalk_environment_id    = "${module.api.elastic_beanstalk_environment_id}"
  environment                         = "${local.environment}"
  organization                        = "${var.organization}"
  web_address_client_panel            = "${local.web_address_client_panel}"
}

# Backoffice

module "backoffice" {
  source                                           = "./backoffice"
  organization                                     = "${var.organization}"
  web_address_backoffice                           = "${local.web_address_backoffice}"
  elastic_beanstalk_environment_id_client_panel    = "${module.api.elastic_beanstalk_environment_id}"
  elastic_beanstalk_environment_cname_client_panel = "${module.api.elastic_beanstalk_environment_cname}"
}
