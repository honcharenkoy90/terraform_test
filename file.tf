resource "aws_instance" "web" {
  instance_type = "t1.micro"
  tags {
    Name = "test_tf"
  }
  ami = ""
}
