resource "aws_vpc" "hm-vpc" {
  cidr_block = "${var.vpc_cidr}"
  enable_dns_hostnames = true
  enable_dns_support = true

  tags {
    Name = "VPC-${var.project}-${terraform.workspace}"
    env  = "${terraform.workspace}"
  }
}

resource "aws_subnet" "hm-sub-private" {
  count = 3
  vpc_id = "${aws_vpc.hm-vpc.id}"

  cidr_block = "${element(split(", ", var.private_subnet_cidrs), count.index)}"
  availability_zone = "${element(split(", ", var.aws_azs), count.index)}"
  tags {
    Name = "subnet-private-${var.project}-${terraform.workspace}"
    env  = "${terraform.workspace}"
  }
}

resource "aws_subnet" "hm-sub-public" {
  count = 3
  vpc_id = "${aws_vpc.hm-vpc.id}"

  cidr_block = "${element(split(", ", var.public_subnet_cidrs), count.index)}"
  availability_zone = "${element(split(", ", var.aws_azs), count.index)}"

  tags {
    Name = "subnet-public-${var.project}-${terraform.workspace}"
    env  = "${terraform.workspace}"
  }
}

resource "aws_internet_gateway" "hm-igw" {
  vpc_id = "${aws_vpc.hm-vpc.id}"
}

resource "aws_route_table" "hm-public-rt" {
  vpc_id = "${aws_vpc.hm-vpc.id}"
}

resource "aws_route_table_association" "hm-rt-assosiation" {
  route_table_id = "${aws_route_table.hm-public-rt.id}"
  subnet_id = "${element(aws_subnet.hm-sub-public.*.id, count.index)}"
}

resource "aws_route" "inet_route" {
  route_table_id = "${aws_route_table.hm-public-rt.id}"
  destination_cidr_block = "0.0.0.0/0"
  gateway_id = "${aws_internet_gateway.hm-igw.id}"
}