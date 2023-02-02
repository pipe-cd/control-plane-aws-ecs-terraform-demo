
resource "aws_elasticache_subnet_group" "main" {
  description = "${var.project}-redis-sg"
  name        = "${var.project}-redis-sg"
  subnet_ids = [
    aws_subnet.private_a.id, aws_subnet.private_c.id, aws_subnet.private_d.id
  ]
}