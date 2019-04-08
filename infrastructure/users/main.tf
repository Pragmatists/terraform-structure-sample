provider "aws" {
  version = "~> 2.2.0"
  region  = "eu-central-1"
}

resource "aws_iam_user" "asset_store" {
  name = "asset_store"
}
