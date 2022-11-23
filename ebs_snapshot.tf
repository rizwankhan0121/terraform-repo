resource "aws_ebs_snapshot" "example_snapshot" {
  volume_id = "vol-0d8457e55bcbb74df"

  tags = {
    Name = "TerraformEC2VolumeSnapshot"
  }
}


resource "aws_ebs_volume" "volume_snapshot" {
  availability_zone = "eu-west-2b"
  size              = 8

  tags = {
    Name = "VolumeSnapshot"
  }
}

resource "aws_instance" "example" {
  ami               = "ami-0648ea225c13e0729"
  availability_zone = "eu-west-2b"
  instance_type     = "t2.micro"

  tags = {
    Name = "DemoEC2EBSVolume_2b"
  }
}

resource "aws_volume_attachment" "ebs_vol_att" {
  device_name = "/dev/sdh"
  volume_id   = aws_ebs_volume.volume_snapshot.id
  instance_id = aws_instance.example.id
}
