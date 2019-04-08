locals {
  brand                    = "pl-brand-one"
  environment              = "prod"
  environment_name         = "pl-brand-one-prod"
  web_address_client_panel = "client-panel.brand-one.example.pl"
}

# DNS

module "dns" {
  source       = "./dns"
  organization = "${var.organization}"
  domain       = "${local.web_address_client_panel}"
}

# API

module "api" {
  source                    = "../../../../infrastructure/api/prod"
  organization              = "${var.organization}"
  application_name          = "${var.application_name}"
  environment_name          = "${local.environment_name}"
  ec2_key_name              = "${var.ec2_key_name}"
  instances_max_count       = 2
  vpc_id                    = "${var.vpc_id}"
  public_subnet_ids         = "${var.public_subnet_ids}"
  region                    = "${var.region}"
  elasticbeanstalk_ec2_role = "${var.elasticbeanstalk_ec2_role}"
}

# Client Panel

module "client_panel_bucket" {
  source = "../../../../infrastructure/client-panel/bucket"

  organization = "${var.organization}"
  bucket_name  = "pl-brand-one-client-panel-prod"
}

module "client_panel_cdn_certificate" {
  source = "../../../../infrastructure/cdn/ssl-certificate"

  web_address     = "${local.web_address_client_panel}"
  route53_zone_id = "${module.dns.route53_zone_id}"
  organization    = "${var.organization}"
}

module "client_panel_cdn" {
  source = "../../../../infrastructure/client-panel/cdn"

  aliases                             = [
    "${local.web_address_client_panel}",
    "www.${local.web_address_client_panel}",
  ]
  brand                               = "${local.brand}"
  elastic_beanstalk_environment_cname = "${module.api.elastic_beanstalk_environment_cname}"
  elastic_beanstalk_environment_id    = "${module.api.elastic_beanstalk_environment_id}"
  environment                         = "${local.environment}"
  organization                        = "${var.organization}"
  s3_bucket_id                        = "${module.client_panel_bucket.s3_bucket_id}"
  s3_bucket_regional_domain_name      = "${module.client_panel_bucket.s3_bucket_regional_domain_name}"
  ssl_certificate_arn                 = "${module.client_panel_cdn_certificate.certificate_arn}"
}

module "client_panel_dns" {
  source = "../../../../infrastructure/cdn/dns"

  route53_zone_id = "${module.dns.route53_zone_id}"
  web_addresses   = [
    "${local.web_address_client_panel}",
  ]
  alias_name      = "${module.client_panel_cdn.domain_name}"
  alias_zone_id   = "${module.client_panel_cdn.hosted_zone_id}"
}
