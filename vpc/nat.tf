resource "aws_eip" "nat" {
  vpc = true

  tags = {
    Name = "${var.project}-nat"
  }
}

resource "aws_nat_gateway" "main" {
  subnet_id     = aws_subnet.public_a.id
  allocation_id = aws_eip.nat.id
  tags = {
    Name = "${var.project}-nat"
  }
  depends_on = [aws_internet_gateway.main]
}
