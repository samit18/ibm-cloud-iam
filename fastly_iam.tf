# IAM things
# Could refactor to use a group if we know the aws user names, but 
# here I simply use a Role and Pnstance Profile for each instance
resource "aws_iam_instance_profile" "test_profile" {
  count = "${var.server_count}"
  name  = "test_profile_${count.index}"
  role  = "${element(aws_iam_role.role.*.name, count.index)}"
}

resource "aws_iam_role" "role" {
  count = "${var.server_count}"
  name  = "test_role_${count.index}"
  count = "${var.server_count}"
  path  = "/"

  assume_role_policy = <<EOF
{
    "Version": "2008-10-17",
    "Statement": [
        {
            "Action": "sts:AssumeRole",
            "Principal": {"AWS": "*"},
            "Effect": "Allow",
            "Sid": ""
        }
    ]
}
EOF
}

resource "aws_iam_role_policy" "replication" {
  count = "${var.server_count}"
  role  = "${element(aws_iam_role.role.*.id, count.index)}"
  name  = "715489234-replication-policy"

  policy = <<POLICY
{
  "Version": "2012-10-17",
  "Statement": [
    {
       "Effect":"Allow",
       "Action":[
          "s3:ListBucket",
          "s3:GetBucketLocation"
       ],
       "Resource":"${aws_s3_bucket.bucket.arn}"
    },
    {
       "Effect":"Allow",
       "Action":[
          "s3:*"
       ],
       "Resource":"${aws_s3_bucket.bucket.arn}/user${count.index}/*"
    }
  ]
}
POLICY
}
