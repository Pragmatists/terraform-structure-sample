variable "aws_region" {}
variable "ec2_key_name" {}
variable "elasticbeanstalk_ec2_role" {}
variable "elasticbeanstalk_service_role" {}
variable "organization" {}
variable "public_subnet_ids" {
  type = "list"
}
variable "vpc_id" {}
