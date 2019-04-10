resource "aws_security_group" "InstanceSecGroup" {
  vpc_id      = "vpc-4f1f8934"
  description = "Lesson1 SG for instances and CLB"

  ingress = [
    {
      from_port   = 22
      protocol    = "tcp"
      to_port     = 22
      cidr_blocks = ["0.0.0.0/0"]
    },
  ]
}

resource "aws_instance" "lesson1_instance" {
  ami           = "ami-0565af6e282977273"
  instance_type = "t2.micro"
  count         = 2

  vpc_security_group_ids = ["${aws_security_group.InstanceSecGroup.id}"]
}

resource "aws_elb" "lesson1_elb" {
  "listener" {
    instance_port     = 80
    instance_protocol = "tcp"
    lb_port           = 80
    lb_protocol       = "tcp"
  }

  subnets = ["subnet-960d11f2"]

  security_groups = ["${aws_security_group.InstanceSecGroup.id}"]
  instances       = ["${aws_instance.lesson1_instance.*.id}"]
}