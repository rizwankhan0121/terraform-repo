module "mysg_ec2" {

  source = "./modules/sg"

}

resource "aws_security_group" "allow_http" {
  name        = "my-lb-sg"
  description = "Allow http inbound traffic to Application loadbalancer"
  vpc_id = "vpc-01ee3076d9e04f39d"

  ingress {
    description      = "TLS from VPC"
    from_port        = local.port
    to_port          = local.port
    protocol         = "tcp"
    cidr_blocks      = ["0.0.0.0/0"]
  }

  egress {
    from_port        = 0
    to_port          = 0
    protocol         = "-1"
    cidr_blocks      = ["0.0.0.0/0"]
  }

  tags = {
    Name = "allow_all_http_traffic_to_loadbalancer"
  }
}

locals {

port = 80

}

output "sg_output" {

value = aws_security_group.allow_http.id


}




resource "aws_subnet" "subnet2" {
  vpc_id            = "vpc-01ee3076d9e04f39d"
  cidr_block        = "172.31.32.0/20"
  availability_zone = "eu-west-2b"

  tags = {
    Name = "subnet2"
  }
}


resource "aws_subnet" "subnet1" {
  vpc_id            = "vpc-01ee3076d9e04f39d"
  cidr_block        = "172.31.16.0/20"
  availability_zone = "eu-west-2a"

  tags = {
    Name = "subnet1"
  }
}



resource "aws_instance" "ec2-module" {
depends_on = [aws_security_group.allow_http]

  ami = "ami-0648ea225c13e0729"

  instance_type = "t2.micro"

  associate_public_ip_address = true

  count = 3


  tags = {
    name = "webserver${count.index}"
  }

  vpc_security_group_ids = [module.mysg_ec2.sg_op]

  user_data = <<EOF
  
  #!/bin/bash
  
  yum update -y 

  yum install -y httpd

  systemctl start httpd

  systemctl enable httpd

  echo "This is my webpage hosted on $(hostname -f)" > /var/www/html/index.html
 
  EOF 

  subnet_id = aws_subnet.subnet1.id

}

resource "aws_lb" "alb" {
  name               = "my-test-alb"
  internal           = false
  load_balancer_type = "application"
  security_groups    = [aws_security_group.allow_http.id]
  subnets            = ["subnet-05fbf81a4a30c502a","subnet-0b7944fb91370276a"]

  enable_deletion_protection = true

  tags = {
    Name = "my-demo-alb"
  }
}

resource "aws_lb_target_group" "test" {
  name     = "tf-example-lb-tg"
  port     = 80
  protocol = "HTTP"
  vpc_id   = "vpc-01ee3076d9e04f39d"

  health_check {
    path                = "/"
    healthy_threshold   = 3
    unhealthy_threshold = 3
    timeout             = 4
    interval            = 5
    matcher             = "200,302,303"
  }
  tags = {
    name = "my-target-group"
  }

}

resource "aws_lb_target_group_attachment" "ec2_attach" {
  depends_on       = [aws_lb_target_group.test]
  count            = length(aws_instance.ec2-module)
  target_group_arn = aws_lb_target_group.test.arn
  target_id        = aws_instance.ec2-module[count.index].id
  port             = 80
}


resource "aws_lb_listener" "front_end" {
  depends_on        = [aws_lb.alb]
  load_balancer_arn = aws_lb.alb.arn
  port              = "80"
  protocol          = "HTTP"
  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.test.arn
  }
}


resource "aws_lb_listener_rule" "host_based_weighted_routing" {
  depends_on   = [aws_lb_listener.front_end]
  listener_arn = aws_lb_listener.front_end.arn

  action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.test.arn
  }

  condition {
    path_pattern {
      values = ["/test"]
    }
  }
}
