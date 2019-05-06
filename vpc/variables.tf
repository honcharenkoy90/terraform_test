variable "project" {}
variable "region" {}
variable "profile" {}
variable "shared_creds_file_path" {}
variable "key" {}
variable "env" {}

variable "vpc_cidr" {}
variable "aws_azs" {
  default = "us-east-1a, us-east-1b, us-east-1c, us-east-1d"
}

variable "public_subnet_cidrs" {
  description = "CIDRs for the public subnets"
  default = "10.11.2.0/24, 10.11.3.0/24, 10.11.4.0/24"
}

variable "private_subnet_cidrs" {
  description = "CIDRs for the public subnets"
  default = "10.11.5.0/24, 10.11.6.0/24, 10.11.7.0/24"
}