variable "aliases" {
  type    = "list"
  default = []
}
variable "brand" {}
variable "elastic_beanstalk_environment_cname" {}
variable "elastic_beanstalk_environment_id" {}
variable "environment" {}
variable "organization" {}
variable "s3_bucket_id" {}
variable "s3_bucket_regional_domain_name" {}
variable "ssl_certificate_arn" {
  default = ""
}
