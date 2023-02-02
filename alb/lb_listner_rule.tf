resource "aws_lb_listener_rule" "http" {
  listener_arn = aws_lb_listener.http.arn

  action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.http.arn
  }
  condition {
    path_pattern {
      values = ["*"]
    }
  }
  depends_on = [aws_lb_listener.http]
}

resource "aws_lb_listener_rule" "grpc" {
  listener_arn = aws_lb_listener.grpc.arn

  action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.grpc.arn
  }
  condition {
    path_pattern {
      values = ["*"]
    }
  }
  depends_on = [aws_lb_listener.grpc]
}