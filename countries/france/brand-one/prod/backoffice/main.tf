locals {
  brand       = "fr-brand-one"
  environment = "prod"
}

# S3

module "bucket" {
  source       = "../../../../../infrastructure/backoffice/bucket"
  organization = "${var.organization}"
  bucket_name  = "fr-brand-one-backoffice-prod"
}


# DNS

resource "aws_route53_zone" "default" {
  name = "${var.web_address_backoffice}"

  tags {
    "organization" = "${var.organization}"
  }
}

# SSL

resource "aws_acm_certificate" "default" {
  provider    = "aws.us_east_1"
  domain_name = "${var.web_address_backoffice}"

  subject_alternative_names = [
    "www.${var.web_address_backoffice}",
  ]

  validation_method = "DNS"

  tags {
    "organization" = "${var.organization}"
  }
}

# CDN

module "cloudfront" {
  source = "../../../../../infrastructure/backoffice/cdn"

  aliases                             = ["${var.web_address_backoffice}"]
  brand                               = "${local.brand}"
  elastic_beanstalk_environment_cname = "${var.elastic_beanstalk_environment_cname_client_panel}"
  elastic_beanstalk_environment_id    = "${var.elastic_beanstalk_environment_id_client_panel}"
  environment                         = "${local.environment}"
  organization                        = "${var.organization}"
  s3_bucket_id                        = "${module.bucket.s3_bucket_id}"
  s3_bucket_regional_domain_name      = "${module.bucket.s3_bucket_regional_domain_name}"
  ssl_certificate_arn                 = "${aws_acm_certificate.default.arn}"
}

resource "aws_route53_record" "record_a" {
  name    = "${var.web_address_backoffice}"
  type    = "A"
  zone_id = "${aws_route53_zone.default.id}"

  alias {
    name                   = "${module.cloudfront.domain_name}"
    zone_id                = "${module.cloudfront.hosted_zone_id}"
    evaluate_target_health = false
  }
}

resource "aws_route53_record" "record_aaaa" {
  name    = "${var.web_address_backoffice}"
  type    = "AAAA"
  zone_id = "${aws_route53_zone.default.id}"

  alias {
    name                   = "${module.cloudfront.domain_name}"
    zone_id                = "${module.cloudfront.hosted_zone_id}"
    evaluate_target_health = false
  }
}

