# Configuring credentials for the AWS provider
provider "aws" {
  region                  = "us-east-1"
  shared_credentials_file = "<path-to-your-credentials-files>"
  profile                 = "<your-credentials-profile-name>"
}
