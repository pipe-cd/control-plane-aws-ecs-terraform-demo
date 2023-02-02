resource "aws_db_subnet_group" "main" {
  name = aws_vpc.main.tags.Name

  subnet_ids = [
    aws_subnet.private_a.id, aws_subnet.private_c.id, aws_subnet.private_d.id
  ]

  tags = {
    Name = aws_vpc.main.tags.Name
  }
}