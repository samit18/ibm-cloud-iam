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
- Included a packer template for building an AMI of your own with `awscli`
  preinstalled

Output:

```console
[s3_iam_example](4)$ terraform apply .
aws_iam_role.role.2: Creating...
[...]

Apply complete! Resources: 23 added, 0 changed, 0 destroyed.

Outputs:

bucket_domain_name = s3-iam.s3.amazonaws.com
ip = [
    ec2-34-212-113-195.us-west-2.compute.amazonaws.com,
    ec2-34-212-113-238.us-west-2.compute.amazonaws.com,
    ec2-34-212-113-122.us-west-2.compute.amazonaws.com
]
s3bucket = arn:aws:s3:::s3-iam

[s3_iam_example][master](4)$ ssh -A ubuntu@ec2-34-212-113-195.us-west-2.compute.amazonaws.com

Warning: Permanently added 'ec2-34-212-113-195.us-west-2.compute.amazonaws.com,34.212.113.195' (ECDSA) to the list of known hosts.
Welcome to Ubuntu 16.04.2 LTS (GNU/Linux 4.4.0-66-generic x86_64)

 * Documentation:  https://help.ubuntu.com
 * Management:     https://landscape.canonical.com
 * Support:        https://ubuntu.com/advantage

  Get cloud support with Ubuntu Advantage Cloud Guest:
    http://www.ubuntu.com/business/services/cloud

97 packages can be updated.
44 updates are security updates.

ubuntu@ip-10-0-0-216:~$ aws s3 ls s3://s3-iam/
                           PRE user0/
                           PRE user1/
                           PRE user2/

ubuntu@ip-10-0-0-216:~$ echo "# hello" > hello.md

ubuntu@ip-10-0-0-216:~$ aws s3api put-object --bucket s3-iam --key user0/hello.md --body hello.md
{
    "ETag": "\"487deb0527aa4445bfa958e3dd999279\""
}

ubuntu@ip-10-0-0-216:~$ aws s3api put-object --bucket s3-iam --key user1/hello.md --body hello.md

An error occurred (AccessDenied) when calling the PutObject operation: Access Denied
```
