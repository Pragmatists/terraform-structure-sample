provider "aws" {
  version = "~> 2.2.0"
  region  = "eu-central-1"
}

resource "aws_iam_role" "elasticbeanstalk_ec2" {
  name = "aws-elasticbeanstalk-ec2-role"

  assume_role_policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Effect": "Allow",
      "Principal": {
        "Service": "ec2.amazonaws.com"
      },
      "Action": "sts:AssumeRole"
    }
  ]
}
EOF
}


data "aws_iam_policy" "elastic_beanstalk_web_tier" {
  arn = "arn:aws:iam::aws:policy/AWSElasticBeanstalkWebTier"
}

resource "aws_iam_role_policy_attachment" "elastic_beanstalk_web_tier" {
  policy_arn = "${data.aws_iam_policy.elastic_beanstalk_web_tier.arn}"
  role       = "${aws_iam_role.elasticbeanstalk_ec2.name}"
}


resource "aws_iam_role" "elasticbeanstalk_service" {
  name               = "aws-elasticbeanstalk-service-role"
  assume_role_policy = <<EOF
{
    "Version": "2012-10-17",
    "Statement": [
      {
        "Sid": "",
        "Effect": "Allow",
        "Principal": {
          "Service": "elasticbeanstalk.amazonaws.com"
        },
        "Action": "sts:AssumeRole",
        "Condition": {
          "StringEquals": {
            "sts:ExternalId": "elasticbeanstalk"
          }
        }
      }
    ]
}
EOF
}

data "aws_iam_policy" "AWSElasticBeanstalkEnhancedHealth" {
  arn = "arn:aws:iam::aws:policy/service-role/AWSElasticBeanstalkEnhancedHealth"
}

resource "aws_iam_role_policy_attachment" "AWSElasticBeanstalkEnhancedHealth" {
  role       = "${aws_iam_role.elasticbeanstalk_service.name}"
  policy_arn = "${data.aws_iam_policy.AWSElasticBeanstalkEnhancedHealth.arn}"
}

data "aws_iam_policy" "AWSElasticBeanstalkService" {
  arn = "arn:aws:iam::aws:policy/service-role/AWSElasticBeanstalkService"
}

resource "aws_iam_role_policy_attachment" "AWSElasticBeanstalkService" {
  role       = "${aws_iam_role.elasticbeanstalk_service.name}"
  policy_arn = "${data.aws_iam_policy.AWSElasticBeanstalkService.arn}"
}
