resource "aws_route53_zone" "default" {
  name = "${var.domain}"

  tags {
    "organization" = "${var.organization}"
  }
}

resource "aws_route53_record" "caa" {
  name    = "${var.domain}"
  type    = "CAA"
  zone_id = "${aws_route53_zone.default.zone_id}"
  ttl     = 3600
  records = [
    "0 issue \"amazon.com\"",
    "0 issue \"amazontrust.com\"",
    "0 issue \"awstrust.com\"",
    "0 issue \"amazonaws.com\"",
    "0 issuewild \"amazon.com\"",
    "0 issuewild \"amazontrust.com\"",
    "0 issuewild \"awstrust.com\"",
    "0 issuewild \"amazonaws.com\"",
  ]
}
