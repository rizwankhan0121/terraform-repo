resource "aws_vpc" "vpc_demo" {
  cidr_block = "10.0.0.0/16"
  tags = {
    name = "my-demo-VPC"
  }
}

resource "aws_subnet" "public_subnet1" {
  depends_on              = [aws_vpc.vpc_demo]
  vpc_id                  = aws_vpc.vpc_demo.id
  map_public_ip_on_launch = "true"
  availability_zone       = "eu-west-2a"
  cidr_block              = "10.0.1.0/24"
  tags                    = { name = "PublicSubnet1" }
}


resource "aws_efs_file_system" "myfilesystem" {
lifecycle_policy {
    transition_to_ia = "AFTER_30_DAYS"
  }
  tags = {
    Name = "Myfilesystem"
  }
}


resource "aws_efs_access_point" "test" {
  file_system_id = aws_efs_file_system.myfilesystem.id
}


resource "aws_efs_file_system_policy" "policy" {
  file_system_id = aws_efs_file_system.myfilesystem.id
  policy = <<POLICY
{
    "Version": "2012-10-17",
    "Id": "Policy01",
    "Statement": [
        {
            "Sid": "Statement",
            "Effect": "Allow",
            "Principal": {
                "AWS": "*"
            },
            "Resource": "${aws_efs_file_system.myfilesystem.arn}",
            "Action": [
                "elasticfilesystem:ClientMount",
                "elasticfilesystem:ClientRootAccess",
                "elasticfilesystem:ClientWrite"
            ],
            "Condition": {
                "Bool": {
                    "aws:SecureTransport": "false"
                }
            }
        }
    ]
}
POLICY
}


resource "aws_efs_mount_target" "alpha" {
  file_system_id = aws_efs_file_system.myfilesystem.id
  subnet_id      = aws_subnet.public_subnet1.id
}

resource "aws_instance" "efs_instance" {

ami = "ami-0648ea225c13e0729"
instance_type = "t2.micro"
vpc_security_group_ids = ["sg-0a031b6ec5786e1b9"]
}

