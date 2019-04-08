data "aws_iam_role" "beanstalk_service" {
  name = "${var.elasticbeanstalk_service_role}"
}

resource "aws_elastic_beanstalk_application" "default" {
  name = "${var.name}"

  appversion_lifecycle {
    service_role          = "${data.aws_iam_role.beanstalk_service.arn}"
    max_age_in_days       = 30
    delete_source_from_s3 = true
  }
}
