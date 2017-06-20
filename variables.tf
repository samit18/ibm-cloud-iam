output "ip" {
  value = ["${aws_instance.tf_test.*.public_dns}"]
}

output "s3bucket" {
  value = "${aws_s3_bucket.bucket.arn}"
}

output "bucket_domain_name" {
  value = "${aws_s3_bucket.bucket.bucket_domain_name}"
}

variable "server_count" {
  default = 3
}
