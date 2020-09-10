# ----- Data sources ----- #
#Ubuntu AMI for an instance
data "aws_ami" "ubuntu_image" {
  most_recent = true

  filter {
    name   = "name"
    values = ["ubuntu/images/hvm-ssd/ubuntu-focal-20.04-amd64-server-*"]
  }

  filter {
    name   = "virtualization-type"
    values = ["hvm"]
  }

  owners = ["099720109477"] # Canonical
}

# ----- Network ----- #
# Main VPC
resource "aws_vpc" "my_test_vpc" {
  cidr_block = "10.199.0.0/22"
  tags = {
    name = "My test VPC"
  }
}

# Subnet in the main VPC
resource "aws_subnet" "subnet_web_server" {
  cidr_block = "10.199.2.0/25"
  vpc_id     = aws_vpc.my_test_vpc.id
}

# ----- Instances ----- #
# AWS security group for web instances
resource "aws_security_group" "web_instance_sg" {
  name   = "allow_ssh_https_from_world"
  vpc_id = aws_vpc.my_test_vpc.id

  ingress {
    description = "HTTPS from the internet"
    from_port   = 443
    to_port     = 443
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    description = "SSH from the internet (not secure approach)"
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

}

# WEB instance
resource "aws_instance" "web" {
  instance_type   = "t2.micro"
  security_groups = [aws_security_group.web_instance_sg.id]
  subnet_id       = aws_subnet.subnet_web_server.id
  tags = {
    Name    = "test_web_instance"
    Purpose = "test"
  }
  ami = data.aws_ami.ubuntu_image.id
}
