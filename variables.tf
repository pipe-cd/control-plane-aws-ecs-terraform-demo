data "aws_caller_identity" "current" {}
//AWS CONSTS
locals {
  AWS = {
    S3 = {
      S3_AP_HOSTED_ZONE_ID                  = "Z2M4EHUR26P7ZW"
      S3_CANONICAL_USER_ID_AWSLOGS_DELIVERY = "c4c1ede66af53448b93c283ce9448c4ba468c9432aa01d700d3878632f77d2d0"
    }
    ALB = {
      AP_ACCOUNT_ID = "582318560864"
    }
  }
}


//export
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
    # config_bucket  = "${local.project}-config"
    filestore_bucket = "${local.project}-filestore"
  }

  ecs = {
    memory = "1024"
    cpu    = "512"
  }

  # ssm = {
  #   path_to_control_plane_config = "/${local.project}/control-plane-config"
  #   path_to_envoy_config = "/${local.project}/envoy-config"
  #   path_to_encryption_key = "/${local.project}/encryption-key"
  # }

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