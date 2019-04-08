variable "organization" {}
variable "application_name" {}
variable "ec2_key_name" {}
variable "vpc_id" {}
variable "public_subnet_ids" {
  type = "list"
}
variable "region" {}
variable "elasticbeanstalk_ec2_role" {}
