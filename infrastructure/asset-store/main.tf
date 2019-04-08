resource "random_string" "bucket_name" {
  length  = 12
  special = false
  upper   = false

  keepers {
    bucket_name = "${var.country}"
  }
}

locals {
  s3_bucket = "${var.country}-asset-store-${random_string.bucket_name.result}"
}

data "template_file" "s3_bucket_policy" {
  template = "${file("${path.module}/policy-s3-asset-store.json.tpl")}"

  vars {
    s3_bucket = "${local.s3_bucket}"
  }
}

resource "aws_s3_bucket" "default" {
  bucket = "${local.s3_bucket}"
  policy = "${data.template_file.s3_bucket_policy.rendered}"

  tags {
    "organization" = "${var.organization}"
  }
}

# Access

data "template_file" "iam_s3_user_access" {
  template = "${file("${path.module}/policy-iam-s3-user-access.json.tpl")}"

  vars {
    s3_bucket = "${local.s3_bucket}"
  }
}

resource "aws_iam_user_policy" "iam_s3_user_access" {
  policy = "${data.template_file.iam_s3_user_access.rendered}"
  user   = "${var.user_name}"
  name   = "${local.s3_bucket}"
}
