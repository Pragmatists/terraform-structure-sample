variable "aws_regions" {
  default = {
    paris     = "eu-west-3"
    frankfurt = "eu-central-1"
    virginia  = "us-east-1"
  }
  type    = "map"
}

variable "ec2_key_name" {
  default = "Pragmatists"
}
