resource "aws_lb_listener" "main" {
  port            = "443"
  protocol        = "HTTPS"
  depends_on      = [aws_lb_target_group.grpc, aws_lb_target_group.http]
  certificate_arn = var.certificate_arn

  load_balancer_arn = aws_lb.main.arn

  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.grpc.arn
  }
}