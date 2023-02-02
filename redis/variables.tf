variable "project" {
  type    = string
  default = ""
}

variable "tags" {
  type    = map(any)
  default = {}
}
variable "node_type" {
  type    = string
  default = ""
}
variable "vpc_id" {
  type    = string
  default = ""
}
variable "redis_subnet_group_name" {
  type    = string
  default = ""
}