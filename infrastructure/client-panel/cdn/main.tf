locals {
  comment = "${var.brand}-client-panel-${var.environment}"
}

resource "aws_cloudfront_distribution" "default" {
  comment             = "${local.comment}"
  enabled             = true
  price_class         = "PriceClass_100"
  http_version        = "http2"
  is_ipv6_enabled     = true
  aliases             = ["${var.aliases}"]
  default_root_object = "index.html"

  tags {
    "organization" = "${var.organization}"
  }

  origin {
    origin_id   = "${var.s3_bucket_id}"
    domain_name = "${var.s3_bucket_regional_domain_name}"
  }

  origin {
    origin_id   = "${var.elastic_beanstalk_environment_id}"
    domain_name = "${var.elastic_beanstalk_environment_cname}"

    custom_origin_config {
      http_port              = 80
      https_port             = 443
      origin_protocol_policy = "http-only"
      origin_ssl_protocols   = ["TLSv1.2"]
    }
  }

  default_cache_behavior {
    allowed_methods  = ["GET", "HEAD", "OPTIONS"]
    cached_methods   = ["GET", "HEAD"]
    target_origin_id = "${var.s3_bucket_id}"

    forwarded_values {
      query_string = true

      cookies {
        forward = "none"
      }
    }

    min_ttl     = 60
    default_ttl = "${60 * 5}"
    max_ttl     = "${60 * 60}"

    viewer_protocol_policy = "redirect-to-https"
    compress               = true
  }

  ordered_cache_behavior {
    path_pattern     = "/api/*"
    allowed_methods  = ["GET", "HEAD", "DELETE", "OPTIONS", "PATCH", "POST", "PUT"]
    cached_methods   = ["GET", "HEAD"]
    target_origin_id = "${var.elastic_beanstalk_environment_id}"

    forwarded_values {
      query_string = true
      headers      = ["*"]

      cookies {
        forward = "all"
      }
    }

    min_ttl     = 0
    default_ttl = 0
    max_ttl     = 0

    viewer_protocol_policy = "redirect-to-https"
    compress               = true
  }

  restrictions {
    geo_restriction {
      restriction_type = "none"
    }
  }

  viewer_certificate {
    cloudfront_default_certificate = "${var.ssl_certificate_arn == "" ? true : false}"
    acm_certificate_arn            = "${var.ssl_certificate_arn != "" ? var.ssl_certificate_arn : ""}"
    ssl_support_method             = "${var.ssl_certificate_arn != "" ? "sni-only" : ""}"
    minimum_protocol_version       = "${var.ssl_certificate_arn != "" ? "TLSv1.1_2016" : "TLSv1"}"
  }
}
