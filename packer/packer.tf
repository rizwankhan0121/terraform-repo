resource "aws_instance" "instance_from_packer" {
instance_type = "t2.medium"
ami = data.aws_ami.example.id
subnet_id = "subnet-0a365d4f3eed934a6"
iam_instance_profile = "AmazonSSMRoleForInstancesQuickSetup"
associate_public_ip_address = "true"
}



data "aws_ami" "example" {
  most_recent      = true
 # name_regex       = "^packer"
  owners           = ["self"]
}

