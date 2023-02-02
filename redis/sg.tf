resource "aws_security_group" "redis" {
  name                   = "${var.project}-redis-sg"
  description            = "allow access to redis"
  vpc_id                 = var.vpc_id
  revoke_rules_on_delete = false

  tags = {
    Name = "${var.project}-redis"
  }

  egress {
    cidr_blocks = ["0.0.0.0/0"]
    from_port   = "0"
    protocol    = "-1"
    self        = false
    to_port     = "0"
  }
}