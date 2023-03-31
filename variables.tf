data "aws_caller_identity" "current" {}

locals {
  project = "example-pipecd-control-plane"
  alb = {
    certificate_arn  = ""
    http_host_header = ""
  }

  redis = {
    node_type = "cache.t2.micro"
  }

  rds = {
    node_type = "db.t3.micro"
  }

  s3 = { # These must be unique in the world.
    filestore_bucket = ""
  }

  ecs = {
    memory = "1024"
    cpu    = "512"
  }
  kms = {
    kms_decryption_key_id = "aws/secretsmanager"
  }

  sm = {
    control_plane_config_secret = ""
    envoy_config_secret         = ""
    encryption_key_secret       = ""
  }
}

locals {
  basicTags = {
    Product = "${local.project}"
  }
  componentType = {
    computing       = { "CostComponentType" = "Computing" }
    storage         = { "CostComponentType" = "Storage" }
    database        = { "CostComponentType" = "Database" }
    networking      = { "CostComponentType" = "Networking" }
    queue           = { "CostComponentType" = "Queue" }
    operation       = { "CostComponentType" = "Operation" }
    other           = { "CostComponentType" = "Other" }
    storageDatabase = { "CostComponentType" = "Storage_Database" }
  }
}
