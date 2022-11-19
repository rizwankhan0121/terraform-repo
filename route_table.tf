resource "aws_route_table" "PublicRoute" {
  vpc_id = aws_vpc.vpc_demo.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.demoIGW.id
  }

  tags = {
    Name = "PublicRoute"
  }
}

resource "aws_route_table_association" "a" {
  depends_on     = [aws_route_table.PublicRoute]
  subnet_id      = aws_subnet.public_subnet.id
  route_table_id = aws_route_table.PublicRoute.id
}
