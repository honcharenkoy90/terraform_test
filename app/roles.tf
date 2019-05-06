resource "aws_iam_role" "hm-s3-full" {
  name               = "s3_access_role"
  assume_role_policy = "${file("../files/s3role.json")}"

  tags {
    name = "s3_access_role"
    env  = "${terraform.workspace}"
  }
}

resource "aws_iam_instance_profile" "hm-iam-profile" {
  name = "gm-instance-profile"
  role = "${aws_iam_role.hm-s3-full.name}"
}

resource "aws_iam_role_policy" "hm-s3-policy" {
  name = "s3-policy"

  policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Action": [
        "s3:*"
      ],
      "Effect": "Allow",
      "Resource": "${aws_s3_bucket.testbucket.arn}/*"
    }
  ]
}
EOF

  role = "${aws_iam_role.hm-s3-full.id}"
}
