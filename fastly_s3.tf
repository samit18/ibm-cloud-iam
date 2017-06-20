resource "aws_s3_bucket" "bucket" {
  bucket = "s3-iam"

  tags {
    Name = "s3-iam-limit"
  }
}

resource "aws_s3_bucket_object" "object" {
  count  = "${var.server_count}"
  bucket = "${aws_s3_bucket.bucket.id}"
  key    = "user${count.index}/"

  # empty subfolder
  source = "/dev/null"
}
