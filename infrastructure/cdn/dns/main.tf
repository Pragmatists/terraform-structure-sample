resource "aws_route53_record" "record_a" {
  count   = "${length(var.web_addresses)}"
  name    = "${element(var.web_addresses, count.index)}"
  type    = "A"
  zone_id = "${var.route53_zone_id}"

  alias {
    name                   = "${var.alias_name}"
    zone_id                = "${var.alias_zone_id}"
    evaluate_target_health = false
  }
}

resource "aws_route53_record" "record_aaaa" {
  count   = "${length(var.web_addresses)}"
  name    = "${element(var.web_addresses, count.index)}"
  type    = "AAAA"
  zone_id = "${var.route53_zone_id}"

  alias {
    name                   = "${var.alias_name}"
    zone_id                = "${var.alias_zone_id}"
    evaluate_target_health = false
  }
}

resource "aws_route53_record" "record_cname_www" {
  count   = "${length(var.web_addresses)}"
  name    = "www.${element(var.web_addresses, count.index)}"
  zone_id = "${var.route53_zone_id}"
  type    = "CNAME"
  ttl     = 300
  records = ["${element(var.web_addresses, count.index)}"]
}
