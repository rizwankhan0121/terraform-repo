resource "aws_launch_template" "demo_template" {
  name_prefix   = "my_asg"
  image_id      = "ami-0648ea225c13e0729"
  instance_type = "t2.micro"
}

resource "aws_autoscaling_group" "demoasg" {
  availability_zones = ["eu-west-2a"]
  desired_capacity   = 1
  max_size           = 1
  min_size           = 1

  launch_template {
    id      = aws_launch_template.demo_template.id
    version = "$Latest"
  }
}
