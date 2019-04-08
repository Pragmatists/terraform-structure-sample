resource "aws_route53_zone" "default" {
  name = "${var.web_address_client_panel}"

  tags {
    "organization" = "${var.organization}"
  }
}

module "client_panel_bucket" {
  source = "../../../../../infrastructure/client-panel/bucket"

  organization = "${var.organization}"
  bucket_name  = "fr-brand-one-client-panel-prod"
}

module "client_panel_cdn_certificate" {
  source = "../../../../../infrastructure/cdn/ssl-certificate"

  web_address     = "${var.web_address_client_panel}"
  route53_zone_id = "${aws_route53_zone.default.id}"
  organization    = "${var.organization}"
}

module "client_panel_cdn" {
  source = "../../../../../infrastructure/client-panel/cdn"

  aliases                             = [
    "${var.web_address_client_panel}",
    "www.${var.web_address_client_panel}",
  ]
  brand                               = "${var.brand}"
  elastic_beanstalk_environment_cname = "${var.elastic_beanstalk_environment_cname}"
  elastic_beanstalk_environment_id    = "${var.elastic_beanstalk_environment_id}"
  environment                         = "${var.environment}"
  organization                        = "${var.organization}"
  s3_bucket_id                        = "${module.client_panel_bucket.s3_bucket_id}"
  s3_bucket_regional_domain_name      = "${module.client_panel_bucket.s3_bucket_regional_domain_name}"
  ssl_certificate_arn                 = "${module.client_panel_cdn_certificate.certificate_arn}"
}

module "client_panel_dns" {
  source = "../../../../../infrastructure/cdn/dns"

  route53_zone_id = "${aws_route53_zone.default.id}"
  web_addresses   = [
    "${var.web_address_client_panel}",
  ]
  alias_name      = "${module.client_panel_cdn.domain_name}"
  alias_zone_id   = "${module.client_panel_cdn.hosted_zone_id}"
}
