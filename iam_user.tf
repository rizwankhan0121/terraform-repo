resource "aws_iam_user" "iam_user" {
  name = "ridha"
  path = "/system/"

  tags = {
    tag-key = "Administrator"
  }
}

resource "aws_iam_user" "myself" {
name = "rizwan"
path = "/system/"
}

resource "aws_iam_group" "admin" {
  name = "administrator"
  path = "/"
}

resource "aws_iam_user_group_membership" "user_add" {
  user = aws_iam_user.iam_user.name

  groups = [
    aws_iam_group.admin.name
  ]
}

resource "aws_iam_policy" "policy" {
  name        = "test-policy"
  description = "A test policy"

  policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Action": [
        "ec2:Describe*"
      ],
      "Effect": "Allow",
      "Resource": "*"
    }
  ]
}
EOF
}

 resource "aws_iam_policy_attachment" "test-attach" {
  name       = "test-attachment"
  users      = [aws_iam_user.iam_user.name]
  policy_arn = aws_iam_policy.policy.arn
} 
