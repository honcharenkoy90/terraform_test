provider "aws" {
  region                  = "us-east-1"
  shared_credentials_file = "/home/vagrant/.aws/creds"
  profile                 = "tf_user2"
}
