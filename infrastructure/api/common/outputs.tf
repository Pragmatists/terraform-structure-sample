output "solution_name" {
  value = "64bit Amazon Linux 2018.03 v2.8.2 running Java 8"
}

output "instance_type" {
  value = {
    eu-central-1 = "t3.micro"
    eu-west-3    = "t3.micro"
  }
}

output "aws_ses_regions" {
  value = {
    eu-central-1 = "eu-west-1"
    eu-west-3 = "eu-west-1"
  }
}
