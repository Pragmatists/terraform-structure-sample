variable "organization" {}
variable "ec2_key_name" {}
variable "vpc_id" {}
variable "public_subnet_ids" {
  type = "list"
}
variable "application_name" {}
variable "region" {}
variable "elasticbeanstalk_ec2_role" {}
