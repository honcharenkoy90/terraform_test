resource "aws_s3_bucket" "testbucket" {
  versioning {
    enabled = true
  }

  bucket = "${var.bucket_name}-${var.project}"

  tags {
    Env = "${terraform.workspace}"
  }
}

resource "aws_s3_bucket_object" "hm-s3-object-conf" {
  bucket = "${aws_s3_bucket.testbucket.id}"
  key    = "nginx.conf"
  source = "../files/nginx.conf"
}

resource "aws_s3_bucket_object" "hm-s3-object-site" {
  bucket = "${aws_s3_bucket.testbucket.id}"
  key    = "index.html"
  source = "../files/index.html"
}
