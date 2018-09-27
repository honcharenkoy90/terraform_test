
resource "aws_vpc" "NetworkForAlb" {
  cidr_block = "${var.vpc_cidr}"
  enable_dns_hostnames = "true"
  enable_dns_support = "true"
  tags {
    name = "NetworkForAlb"
  }
}

resource "aws_subnet" "PubSubnet1" {
  cidr_block = "${var.sub1_cidr}"
  vpc_id = "${aws_vpc.NetworkForAlb.id}"
  availability_zone = "${var.sub1_az}"
  tags {
    name = "PubSubnet1Alb"
    network = "ForNetworkForAlb"
  }
}

resource "aws_subnet" "PubSubnet2" {
  cidr_block = "${var.sub2_cidr}"
  vpc_id = "${aws_vpc.NetworkForAlb.id}"
  availability_zone = "${var.sub2_az}"
  tags {
    name = "PubSubnet2Alb"
    network = "ForNetworkForAlb"
  }
}

resource "aws_internet_gateway" "InternetGateway" {
  vpc_id = "${aws_vpc.NetworkForAlb.id}"
  tags {
    name = "InetGatewayAlb"
    network = "ForNetworkForAlb"
  }
}
resource "aws_route_table" "PubRouteTable" {
  vpc_id = "${aws_vpc.NetworkForAlb.id}"
  tags {
    name = "PubRouteTableAlb"
    network = "ForNetworkForAlb"
  }
}

resource "aws_route" "PubRoute" {
//  depends_on = "${aws_internet_gateway.InternetGateway.}"
  route_table_id = "${aws_route_table.PubRouteTable.id}"
  destination_cidr_block = "${var.all_allow_cidr}"
  gateway_id = "${aws_internet_gateway.InternetGateway.id}"
}

resource "aws_route_table_association" "SubnetRTAssosiation" {
  route_table_id = "${aws_route_table.PubRouteTable.id}"
  subnet_id = "${aws_subnet.PubSubnet1.id}"
}

resource "aws_network_acl" "PubNetworkAcl" {
  vpc_id = "${aws_vpc.NetworkForAlb.id}"
  subnet_id = "${aws_subnet.PubSubnet1.id}"
  tags {
    name = "NetworkAclAlb"
    network = "ForNetworkForAlb"
  }
}

resource "aws_network_acl_rule" "InboundHTTPRulePublic" {
  network_acl_id = "${aws_network_acl.PubNetworkAcl.id}"
  protocol = "6"
  rule_action = "allow"
  rule_number = "100"
  egress = "false"
  cidr_block = "${var.all_allow_cidr}"
  from_port = "80"
  to_port = "80"
}

resource "aws_network_acl_rule" "InboundHTTPSRulePublic" {
  network_acl_id = "${aws_network_acl.PubNetworkAcl.id}"
  protocol = "6"
  rule_action = "allow"
  rule_number = "101"
  egress = "false"
  cidr_block = "${var.all_allow_cidr}"
  from_port = "443"
  to_port = "443"
}

resource "aws_network_acl_rule" "InboundSSHRulePublic" {
  network_acl_id = "${aws_network_acl.PubNetworkAcl.id}"
  protocol = "6"
  rule_action = "allow"
  rule_number = "102"
  egress = "false"
  cidr_block = "${var.all_allow_cidr}"
  from_port = "22"
  to_port = "22"
}

resource "aws_network_acl_rule" "OutboundRulePublic" {
  network_acl_id = "${aws_network_acl.PubNetworkAcl.id}"
  protocol = "6"
  rule_action = "allow"
  rule_number = "100"
  egress = "true"
  cidr_block = "${var.all_allow_cidr}"
  from_port = "0"
  to_port = "65535"
}

output "PubSubnet1" {
  value = "${aws_subnet.PubSubnet1.id}"
}

output "PubSubnet2" {
  value = "${aws_subnet.PubSubnet2.id}"
}

output "VPC_id" {
  value = "${aws_vpc.NetworkForAlb.id}"
}