resource "aws_vpc" "main" {
  cidr_block                       = "10.0.0.0/16"
  enable_classiclink               = false
  enable_classiclink_dns_support   = false
  enable_dns_hostnames             = true
  enable_dns_support               = true
  instance_tenancy                 = "default"
  assign_generated_ipv6_cidr_block = false

  tags = merge(var.tags, { "Name" = "${var.project}" })
  # lifecycle {
  #   prevent_destroy = var.prevent_destroy
  # }
}