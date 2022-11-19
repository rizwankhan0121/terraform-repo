resource "aws_instance" "myec2" {

  ami = "ami-0648ea225c13e0729"

  instance_type = local.instance_type

  tags = { name = "MyFirstEC2-module" }

}

locals {

instance_type = "t2.small"

}

