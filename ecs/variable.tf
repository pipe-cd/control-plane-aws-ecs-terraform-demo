variable "project" {
  type    = string
  default = ""
}

variable "tags" {
  type    = map(any)
  default = {}
}
variable "desired_count" {
  type    = number
  default = 1
}
variable "vpc_id" {
  type    = string
  default = ""
}
variable "subnet_id" {
  type    = string
  default = ""
}

variable "gateway_image_url" {
  type    = string
  default = ""
}

variable "server_image_url" {
  type    = string
  default = ""
}

variable "ops_image_url" {
  type    = string
  default = ""
}

variable "memory" {
  type    = string
  default = "1024"
}

variable "cpu" {
  type    = string
  default = "512"
}

variable "log_group_name" {
  type    = string
  default = ""
}
variable "lb_target_group_arn_http" {
  type    = string
  default = ""
}

variable "lb_target_group_arn_grpc" {
  type    = string
  default = ""
}

variable "db_instance_address" {
  type    = string
  default = ""
}

variable "db_security_group_id" {
  type    = string
  default = ""
}

variable "redis_security_group_id" {
  type    = string
  default = ""
}

variable "redis_host" {
  type    = string
  default = ""
}

variable "filestore_bucket_name" {
  type    = string
  default = ""
}

variable "kms_decryption_key_id" {
  type    = string
  default = ""
}

variable "control_plane_config_secret" {
  type    = string
  default = ""
}

variable "envoy_config_secret" {
  type    = string
  default = ""
}

variable "encryption_key_secret" {
  type    = string
  default = ""
}