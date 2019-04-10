resource "aws_s3_bucket" "testbucket" {
  versioning {
    enabled = true
  }

  bucket = "terraform-state-${var.project}"

  tags {
    Name = "lesson1"
    Env  = "stage"
  }
}
