variable "application_name" {}
variable "ec2_key_name" {}
variable "elasticbeanstalk_ec2_role" {}
variable "organization" {}
variable "public_subnet_ids" {
  type = "list"
}
variable "region" {}
variable "vpc_id" {}
