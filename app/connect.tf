provider "aws" {
  region                  = "${var.region}"
  shared_credentials_file = "c:/users/Yurii_Honcharenko/.aws/credentials"
  profile                 = "${var.profile}"
}

terraform {
  backend "s3" {
    bucket                  = "terraform-state-test-lesson1"
    key                     = "lesson1"
    region                  = "us-east-1"
    shared_credentials_file = "C:/Users/Yurii_Honcharenko/.aws/credentials"
    dynamodb_table          = "terraform-lock"
    profile                 = "terraform"
  }
}
