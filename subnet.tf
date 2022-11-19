resource "aws_subnet" "public_subnet" {
  vpc_id                  = aws_vpc.vpc_demo.id
  map_public_ip_on_launch = "true"
  cidr_block              = "10.0.16.0/20"
  tags                    = { name = "PublicSubnet" }
}

resource "aws_subnet" "private_subnet" {
  vpc_id     = aws_vpc.vpc_demo.id
  cidr_block = "10.0.32.0/20"
  tags       = { name = "PrivateiSubnet" }
}
