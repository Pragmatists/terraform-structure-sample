output "elastic_beanstalk_environment_id" {
  value = "${aws_elastic_beanstalk_environment.default.id}"
}

output "elastic_beanstalk_environment_name" {
  value = "${aws_elastic_beanstalk_environment.default.name}"
}

output "elastic_beanstalk_environment_cname" {
  value = "${aws_elastic_beanstalk_environment.default.cname}"
}
