resource "aws_security_group_rule" "db_from_server" {
  type                     = "ingress"
  from_port                = 3306
  to_port                  = 3306
  protocol                 = "tcp"
  security_group_id        = var.db_security_group_id
  source_security_group_id = aws_security_group.server.id
}

resource "aws_security_group_rule" "db_from_ops" {
  type                     = "ingress"
  from_port                = 3306
  to_port                  = 3306
  protocol                 = "tcp"
  security_group_id        = var.db_security_group_id
  source_security_group_id = aws_security_group.ops.id
}