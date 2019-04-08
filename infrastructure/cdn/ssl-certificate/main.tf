resource "aws_acm_certificate" "default" {
  provider                  = "aws.us_east_1"
  domain_name               = "${var.web_address}"
  validation_method         = "DNS"
  subject_alternative_names = [
    "www.${var.web_address}",
  ]

  tags {
    "organization" = "${var.organization}"
  }
}

resource "aws_route53_record" "cert_validation" {
  name    = "${aws_acm_certificate.default.domain_validation_options.0.resource_record_name}"
  type    = "${aws_acm_certificate.default.domain_validation_options.0.resource_record_type}"
  zone_id = "${var.route53_zone_id}"
  records = ["${aws_acm_certificate.default.domain_validation_options.0.resource_record_value}"]
  ttl     = 60
}

resource "aws_route53_record" "cert_validation_alt1" {
  name    = "${aws_acm_certificate.default.domain_validation_options.1.resource_record_name}"
  type    = "${aws_acm_certificate.default.domain_validation_options.1.resource_record_type}"
  zone_id = "${var.route53_zone_id}"
  records = ["${aws_acm_certificate.default.domain_validation_options.1.resource_record_value}"]
  ttl     = 60
}

resource "aws_acm_certificate_validation" "cert" {
  provider                = "aws.us_east_1"
  certificate_arn         = "${aws_acm_certificate.default.arn}"
  validation_record_fqdns = [
    "${aws_route53_record.cert_validation.fqdn}",
    "${aws_route53_record.cert_validation_alt1.fqdn}",
  ]
}
