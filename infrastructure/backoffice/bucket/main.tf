resource "random_string" "bucket_name" {
  length  = 12
  special = false
  upper   = false
  keepers {
    bucket_name = "${var.bucket_name}"
  }
}

locals {
  s3_bucket = "${var.bucket_name}-${random_string.bucket_name.result}"
}

data "template_file" "s3_bucket_policy" {
  template = "${file("${path.module}/policy-s3-backoffice.json.tpl")}"

  vars {
    s3_bucket = "${local.s3_bucket}"
  }
}

resource "aws_s3_bucket" "default" {
  bucket = "${local.s3_bucket}"
  acl    = "public-read"
  policy = "${data.template_file.s3_bucket_policy.rendered}"

  website {
    index_document = "index.html"
  }

  tags {
    "organization" = "${var.organization}"
  }
}
