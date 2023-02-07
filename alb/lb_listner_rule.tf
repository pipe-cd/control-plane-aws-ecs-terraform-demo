resource "aws_lb_listener_rule" "http" {
  listener_arn = aws_lb_listener.main.arn

  action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.http.arn
  }
  condition {
    host_header {
      values = [var.http_host_header]
    }
  }
  depends_on = [aws_lb_listener.main]
}
