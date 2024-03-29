resource "aws_ebs_volume" "example" {
  availability_zone = "eu-west-2a"
  size              = 2

  tags = {
    Name = "demoEBSVolume"
  }
}

resource "aws_volume_attachment" "ebs_att" {
  device_name = "/dev/sdh"
  volume_id   = aws_ebs_volume.example.id
  instance_id = aws_instance.web.id
}

resource "aws_instance" "web" {
  ami               = "ami-0648ea225c13e0729"
  availability_zone = "eu-west-2a"
  instance_type     = "t2.micro"

  tags = {
    Name = "DemoEC2EBSVolume"
  }
}

