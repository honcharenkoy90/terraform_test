resource "aws_security_group" "hm-sg-elb" {
  vpc_id = "${var.vpc_id_dev}"
  name   = "SG-ELB"

  ingress = [
    {
      from_port   = 80
      protocol    = "tcp"
      to_port     = 80
      cidr_blocks = ["${var.cidr_default}"]
    },
  ],
  egress = [
    {
    from_port = 80
    protocol = "tcp"
    to_port = 80
    cidr_blocks = ["${var.cidr_default}"]
   }
  ]
  tags {
    name = "demo-app-01"
  }
}

resource "aws_security_group" "hm-sg-asg" {
  vpc_id = "${var.vpc_id_dev}"
  name   = "SG-EC2"

  ingress = [
    {
      from_port   = 22
      protocol    = "tcp"
      to_port     = 22
      cidr_blocks = ["${var.cidr_default}"]
    },
    {
      from_port       = 80
      protocol        = "tcp"
      to_port         = 80
      cidr_blocks     = ["${var.cidr_default}"]
    },
  ]

  egress = [
    {
      from_port   = 80
      protocol    = "tcp"
      to_port     = 80
      cidr_blocks = ["${var.cidr_default}"]
    },
    {
      from_port   = 443
      protocol    = "tcp"
      to_port     = 443
      cidr_blocks = ["${var.cidr_default}"]
    },
  ]
  tags {
    name = "demo-app-01"
  }
}

resource "aws_elb" "hm-elb" {
  name = "hm-elb"
  internal = false

  "listener" {
    instance_port     = 80
    instance_protocol = "http"
    lb_port           = 80
    lb_protocol       = "http"
  }

   health_check {
      healthy_threshold   = 10
      interval            = 30
      target              = "HTTP:80/"
      timeout             = 5
      unhealthy_threshold = 2
   }

  security_groups = ["${aws_security_group.hm-sg-elb.id}"]

  subnets = ["subnet-0f7db11acea843ff3", "subnet-0216ef561dcf6fce1", "subnet-0be055035589dcf2d"]

  tags {
    name = "demo-app-01"
  }
}

resource "aws_launch_configuration" "hm-ec2-config" {
  name                        = "hm-ec2-configuratiom"
  image_id                    = "${data.aws_ami.ubuntu-img.id}"
  instance_type               = "t2.micro"
  iam_instance_profile        = "${aws_iam_instance_profile.hm-iam-profile.id}"
  user_data                   = "${data.template_file.hm-ec2-user-data.rendered}"
  security_groups             = ["${aws_security_group.hm-sg-asg.id}"]
  key_name                    = "web"
  associate_public_ip_address = true

}

resource "aws_autoscaling_group" "hm-asg" {
  name                 = "hm-asg"
  max_size             = 1
  min_size             = 1
  launch_configuration = "${aws_launch_configuration.hm-ec2-config.name}"
  vpc_zone_identifier  = ["subnet-0f7db11acea843ff3", "subnet-0216ef561dcf6fce1", "subnet-0be055035589dcf2d"]
  load_balancers       = ["${aws_elb.hm-elb.name}"]

  health_check_type = "ELB"

}
