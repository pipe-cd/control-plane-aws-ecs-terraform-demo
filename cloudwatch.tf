resource "aws_cloudwatch_log_group" "pipecd-main" {
  name              = "pipecd-main-cloudwatch-log-terraform"
  retention_in_days = 90
}
