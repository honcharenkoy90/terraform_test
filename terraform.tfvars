####### Configuration ########
region = "us-east-1"
profile = "tf_test2"
shared_creds_file_path = "/home/vagrant/.aws/creds"
key = "test"
bucket_vpc = "trfm-bucket-vpc"
bucket_alb = "trfm-bucke-test"

######## Network #########
vpc_cidr = "10.0.0.0/16"
sub1_cidr = "10.0.0.0/24"
sub2_cidr = "10.0.1.0/24"
sub1_az = "us-east-1a"
sub2_az = "us-east-1b"
all_allow_cidr = "0.0.0.0/0"