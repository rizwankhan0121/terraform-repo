module "mysg" {

  source = "../../modules/sg"

  port = 443

}

resource "aws_instance" "ec2-module" {

  ami = "ami-0648ea225c13e0729"

  instance_type = "t2.micro"

  vpc_security_group_ids = [module.mysg.sg_op]

  tags = { name = "MyFirstEC2through_sgmodule" }

  user_data = <<EOF
  
  #!/bin/bash
  
  yum update -y 

  yum install -y httpd

  systemctl start httpd

  systemctl enable httpd

  echo "This is my webpage" > /var/www/html/index.html
 

  EOF 

  subnet_id = "subnet-05fbf81a4a30c502a"

}



