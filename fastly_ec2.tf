provider "aws" {
  region = "us-west-2"
}

resource "aws_vpc" "default" {
  cidr_block           = "10.0.0.0/16"
  enable_dns_hostnames = true

  tags {
    Name = "s3-iam-demo"
  }
}

resource "aws_subnet" "tf_test_subnet" {
  vpc_id                  = "${aws_vpc.default.id}"
  cidr_block              = "10.0.0.0/24"
  map_public_ip_on_launch = true

  tags {
    Name = "s3-iam-demo"
  }
}

resource "aws_internet_gateway" "gw" {
  vpc_id = "${aws_vpc.default.id}"

  tags {
    Name = "s3-iam-demo"
  }
}

resource "aws_route_table" "r" {
  vpc_id = "${aws_vpc.default.id}"

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = "${aws_internet_gateway.gw.id}"
  }

  tags {
    Name = "s3-iam-demo"
  }
}

resource "aws_route_table_association" "a" {
  subnet_id      = "${aws_subnet.tf_test_subnet.id}"
  route_table_id = "${aws_route_table.r.id}"
}

resource "aws_security_group" "s3_iam_demo" {
  name        = "s3_iam_demo"
  description = "s3_iam_demo"
  vpc_id      = "${aws_vpc.default.id}"

  ingress {
    from_port   = 0
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
    self        = true
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags {
    Name = "s3-iam-demo"
  }
}

# This key pair is particular to Clint's machine
resource "aws_key_pair" "ssh_thing" {
  key_name   = "tf-testing-c"
  public_key = "${file("~/.ssh/id_rsa.pub")}"
}

resource "aws_instance" "tf_test" {
  count = "${var.server_count}"

  # An AMI based on ami-7ac6491a that has AWS CLI pre-installed for my debugging.
  # can just use ami-7ac6491a and install yourself
  ami = "ami-b81401c1"

  instance_type               = "t2.micro"
  subnet_id                   = "${aws_subnet.tf_test_subnet.id}"
  vpc_security_group_ids      = ["${aws_security_group.s3_iam_demo.id}"]
  key_name                    = "${aws_key_pair.ssh_thing.key_name}"
  associate_public_ip_address = true

  iam_instance_profile = "${element(aws_iam_instance_profile.test_profile.*.name, count.index)}"

  depends_on = ["aws_internet_gateway.gw"]

  tags {
    Name = "s3-iam-demo"
  }
}
