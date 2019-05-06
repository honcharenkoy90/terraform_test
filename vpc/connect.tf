provider "aws" {
  region                  = "${var.region}"
  shared_credentials_file = "${var.shared_creds_file_path}"
  profile                 = "${var.profile}"
}

terraform {
  backend "s3" {
    bucket                  = "terraform-state-test-lesson1"
    key                     = "vpc/terraform.tfstate"
    region                  = "us-east-1"
    shared_credentials_file = "C:/Users/Yurii_Honcharenko/.aws/credentials"
    dynamodb_table          = "terraform-lock"
    profile                 = "terraform"
  }
}
