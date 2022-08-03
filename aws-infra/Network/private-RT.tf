resource "aws_route_table" "terra-RT-private" {
  vpc_id = aws_vpc.terra_vpc.id
  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_nat_gateway.nat.id
  }
}

resource "aws_route_table_association" "private-RT-association-1" {
  subnet_id      = aws_subnet.terra-subnet-private-1.id
  route_table_id = aws_route_table.terra-RT-private.id
}

resource "aws_route_table_association" "private-RT-association-2" {
  subnet_id      = aws_subnet.terra-subnet-private-2.id
  route_table_id = aws_route_table.terra-RT-private.id
}
