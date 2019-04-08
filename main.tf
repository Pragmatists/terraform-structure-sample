provider "aws" {
  version = "~> 2.2.0"
  alias   = "us_east_1"
  region  = "us-east-1"
}

module "roles" {
  source = "./infrastructure/roles"
}

module "users" {
  source = "./infrastructure/users"
}

# Paris AWS Region

module "france" {
  source = "./countries/france"

  aws_region                    = "${var.aws_regions["paris"]}"
  ec2_key_name                  = "${var.ec2_key_name}"
  elasticbeanstalk_ec2_role     = "${module.roles.elasticbeanstalk_ec2_role_name}"
  elasticbeanstalk_service_role = "${module.roles.elasticbeanstalk_service_role_name}"
  organization                  = "france"
}

# Frankfurt AWS Region

module "poland" {
  source = "./countries/poland"

  aws_region                    = "${var.aws_regions["frankfurt"]}"
  ec2_key_name                  = "${var.ec2_key_name}"
  elasticbeanstalk_ec2_role     = "${module.roles.elasticbeanstalk_ec2_role_name}"
  elasticbeanstalk_service_role = "${module.roles.elasticbeanstalk_service_role_name}"
  organization                  = "poland"
  user_names                    = "${module.users.user_names}"
}
