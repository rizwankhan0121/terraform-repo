resource "aws_instance" "instance_from_packer" {
  depends_on = [null_resource.packer]
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

resource "aws_lb" "testalb" {
  name               = "testalb"
  internal           = false
  load_balancer_type = "application"
  security_groups    = ["sg-08c3175fc5f9398a8"]
  subnets            = ["subnet-0a365d4f3eed934a6", "subnet-0a1b42fceeb9c1edf"]

  tags = {
    Environment = "lab-env"
  }
}

resource "aws_lb_target_group" "test" {
  name        = "riz-instance"
  port        = "30107"
  protocol    = "HTTP"
  target_type = "instance"
  vpc_id      = "vpc-0a576c99d22eca9c4"

  health_check {
    healthy_threshold   = 3
    unhealthy_threshold = 3
    protocol            = "HTTP"
    port                = "traffic-port"
    # port = 9091
    path     = "/"
    interval = 30
    matcher  = "200,302,303"
  }
}

resource "aws_lb_listener" "fixed_response_30107" {
  load_balancer_arn = aws_lb.testalb.arn
  port              = "30107"
  protocol          = "HTTP"

default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.test.arn
  }
}
