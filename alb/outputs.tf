output "lb_target_groups_http" {
  value = aws_lb_target_group.http
}

output "lb_target_groups_grpc" {
  value = aws_lb_target_group.grpc
}