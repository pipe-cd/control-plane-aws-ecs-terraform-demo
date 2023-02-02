module "vpc" {
  source  = "./vpc"
  project = local.project
  tags    = merge(local.basicTags, local.componentType.networking)
}

module "alb" {
  source          = "./alb"
  certificate_arn = local.alb.certificate_arn
  project         = local.project
  vpc_id          = module.vpc.vpc_id
  subnet_ids      = [module.vpc.subnet_public_a_id, module.vpc.subnet_public_c_id]
  tags            = merge(local.basicTags, local.componentType.networking)
  depends_on      = [module.vpc]
}

module "redis" {
  source                  = "./redis"
  project                 = local.project
  node_type               = local.redis.node_type
  vpc_id                  = module.vpc.vpc_id
  redis_subnet_group_name = module.vpc.redis_subnet_group_name
  tags                    = merge(local.basicTags, local.componentType.storage)
  depends_on              = [module.vpc]
}

module "rds" {
  source               = "./rds"
  project              = local.project
  node_type            = local.rds.node_type
  db_subnet_group_name = module.vpc.db_subnet_group_name
  vpc_id               = module.vpc.vpc_id
  depends_on           = [module.vpc]
}

module "ecs" {
  source                      = "./ecs"
  project                     = local.project
  tags                        = merge(local.basicTags, local.componentType.networking)
  vpc_id                      = module.vpc.vpc_id
  gateway_image_url           = "envoyproxy/envoy-alpine:v1.18.3"
  server_image_url            = "ghcr.io/pipe-cd/pipecd:v0.41.3"
  ops_image_url               = "ghcr.io/pipe-cd/pipecd:v0.41.3"
  memory                      = local.ecs.memory
  cpu                         = local.ecs.cpu
  subnet_id                   = module.vpc.subnet_private_a_id
  log_group_name              = aws_cloudwatch_log_group.pipecd-main.name
  lb_target_group_arn_http    = module.alb.lb_target_groups_http.arn
  lb_target_group_arn_grpc    = module.alb.lb_target_groups_grpc.arn
  db_instance_address         = module.rds.db_instance_address
  redis_host                  = module.redis.redis_host
  db_security_group_id        = module.rds.aws_security_group_id
  redis_security_group_id     = module.redis.aws_security_group_id
  filestore_bucket_name       = local.s3.filestore_bucket
  control_plane_config_secret = local.sm.control_plane_config_secret
  envoy_config_secret         = local.sm.envoy_config_secret
  encryption_key_secret       = local.sm.encryption_key_secret
  kms_decryption_key_id       = local.kms.kms_decryption_key_id
  depends_on                  = [module.alb, module.rds, module.redis]
}