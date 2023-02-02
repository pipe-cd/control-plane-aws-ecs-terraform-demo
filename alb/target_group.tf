resource "aws_lb_target_group" "http" {
  name                 = "${var.project}-http"
  deregistration_delay = "300"
  health_check {
    enabled             = true
    healthy_threshold   = "5"
    interval            = "300"
    matcher             = "200"
    path                = "/"
    port                = "9090"
    protocol            = "HTTP"
    timeout             = "3"
    unhealthy_threshold = "2"
  }

  load_balancing_algorithm_type = "round_robin"
  port                          = "9090"
  protocol                      = "HTTP"
  protocol_version              = "HTTP2"
  slow_start                    = "0"

  target_type = "ip"
  vpc_id      = var.vpc_id
  tags        = var.tags
}

resource "aws_lb_target_group" "grpc" {
  name                 = "${var.project}-grpc"
  deregistration_delay = "300"
  health_check {
    enabled             = true
    healthy_threshold   = "5"
    interval            = "300"
    matcher             = "0"
    path                = "/"
    port                = "9090"
    protocol            = "HTTP"
    timeout             = "3"
    unhealthy_threshold = "2"
  }

  load_balancing_algorithm_type = "round_robin"
  port                          = "9090"
  protocol                      = "HTTP"
  protocol_version              = "GRPC"
  slow_start                    = "0"

  target_type = "ip"
  vpc_id      = var.vpc_id
  tags        = var.tags
}