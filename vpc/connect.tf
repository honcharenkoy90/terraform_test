provider "aws" {
  region                  = "us-east-1"
  shared_credentials_file = "/home/vagrant/.aws/creds"
  profile                 = "tf_user2"
}

terraform {
  backend "s3" {
    bucket                  = "trfm-bucket-vpc"
    key                     = "test"
    region                  = "us-east-1"
    shared_credentials_file = "/home/vagrant/.aws/creds"
    profile                 = "tf_user2"
  }
}
