data "aws_region" "current" {}

data "aws_caller_identity" "self" {}

data "aws_secretsmanager_secret" "encryption_key" {
  name = "${var.encryption_key_secret}"
}

data "aws_secretsmanager_secret" "control_plane_config" {
  name = "${var.control_plane_config_secret}"
}

data "aws_secretsmanager_secret" "envoy_config" {
  name = "${var.envoy_config_secret}"
}