# IAM things
# Could refactor to use a group if we know the aws user names, but 
# here I simply use a Role and Instance Profile for each instance

resource "aws_iam_instance_profile" "test_profile" {
  count = var.server_count
  name  = "test_profile_${count.index}"
  role  = aws_iam_role.role[count.index].name
}

resource "aws_iam_role" "role" {
  count = var.server_count
  name  = "test_role_${count.index}"
  path  = "/"

  assume_role_policy = <<EOF
{
  "Version": "2008-10-17",
  "Statement": [
    {
      "Action": "sts:AssumeRole",
      "Principal": {
        "Service": "ec2.amazonaws.com"
      },
      "Effect": "Allow",
      "Sid": ""
    }
  ]
}
EOF
}

resource "aws_iam_role_policy" "replication" {
  count = var.server_count
  role  = aws_iam_role.role[count.index].id
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
