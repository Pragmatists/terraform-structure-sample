output "elasticbeanstalk_ec2_role_name" {
  value = "${aws_iam_role.elasticbeanstalk_ec2.name}"
}

output "elasticbeanstalk_service_role_name" {
  value = "${aws_iam_role.elasticbeanstalk_service.name}"
}
