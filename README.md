# AWS S3 and IAM example

This repository provides example
[Terraform](https://github.com/hashicorp/terraform) configuration files to
demonstrate creating a single S3 bucket with sub folders, and creates an
EC2 instance for each with an IAM profile limiting READ/WRITE operations on a
specific bucket for that instance.

Basics:

- 1 shared S3 bucket
- 1 sub folder per instance
- AWS CLI installed on the AMI used, but you can bring your own AMI as long as you can ssh. Used just to confirm S3 permissions
- Bring your own SSH key pair