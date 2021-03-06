
resource "aws_security_group" "InstanceSecGroup" {
  vpc_id = "vpc-0d1557748f1bf9f45"

  ingress = [
    {
      from_port   = 22
      protocol    = "tcp"
      to_port     = 22
      cidr_blocks = ["0.0.0.0/0"]
    },
    {
      from_port   = 80
      protocol    = "tcp"
      to_port     = 80
      cidr_blocks = ["0.0.0.0/0"]
    },
  ]

  egress = [
    {
      from_port   = 22
      protocol    = "tcp"
      to_port     = 22
      cidr_blocks = ["0.0.0.0/0"]
    },
    {
      from_port   = 80
      protocol    = "tcp"
      to_port     = 80
      cidr_blocks = ["0.0.0.0/0"]
    },
  ]
}

resource "aws_alb_target_group" "AlbTargetGroup" {
  port     = 80
  protocol = "HTTP"
  vpc_id   = "${aws_security_group.InstanceSecGroup.vpc_id}"

  health_check {
    interval            = 30
    timeout             = 5
    healthy_threshold   = 3
    unhealthy_threshold = 5
  }

  target_type = "instance"

  stickiness {
    enabled         = true
    type            = "lb_cookie"
    cookie_duration = 180
  }
}

resource "aws_alb" "AppLoadBalancer" {
  security_groups = ["${aws_security_group.InstanceSecGroup.id}"]
  subnets         = ["subnet-045172ad390575727", "subnet-0f469264e3a276b3f"]
}

resource "aws_alb_listener" "AlbListener" {
  "default_action" {
    target_group_arn = "${aws_alb_target_group.AlbTargetGroup.arn}"
    type             = "forward"
  }

  load_balancer_arn = "${aws_alb.AppLoadBalancer.arn}"
  port              = 80
  protocol          = "HTTP"
}


data "template_file" "user_data" {
  template = "${file("${path.module}/templates/usr_data.tpl")}"

  vars {
    cluster = "nginx"
  }
}

resource "aws_instance" "web" {
  instance_type               = "t2.micro"
  key_name                    = "${var.key}"
  subnet_id                   = "subnet-045172ad390575727"
  associate_public_ip_address = true
  security_groups             = ["${aws_security_group.InstanceSecGroup.id}"]

  tags {
    Name = "test_tf"
  }

  ami       = "ami-cfe4b2b0"
  user_data = "${data.template_file.user_data.rendered}"
}

resource "aws_alb_target_group_attachment" "AttachmentToInstance" {
  port             = 80
  target_group_arn = "${aws_alb_target_group.AlbTargetGroup.arn}"
  target_id        = "${aws_instance.web.id}"
}

