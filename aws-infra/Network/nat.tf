resource "aws_nat_gateway" "nat" {
  allocation_id = aws_eip.nat_eip.id
  subnet_id     = aws_subnet.terra-subnet-public-1.id
}

resource "aws_eip" "nat_eip" {
  vpc = true
}

