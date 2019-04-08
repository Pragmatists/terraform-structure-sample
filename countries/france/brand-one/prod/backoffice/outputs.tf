output "certificate_arn" {
  value = "${aws_acm_certificate.default.arn}"
}

output "route53_zone_id" {
  value = "${aws_route53_zone.default.id}"
}

output "s3_bucket_id" {
  value = "${module.bucket.s3_bucket_id}"
}

output "s3_bucket_regional_name" {
  value = "${module.bucket.s3_bucket_regional_domain_name}"
}
