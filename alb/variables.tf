variable "project" {
  type    = string
  default = ""
}

variable "tags" {
  type    = map(any)
  default = {}
}
variable "vpc_id" {
  type    = string
  default = ""
}
variable "subnet_ids" {
  type    = list(any)
  default = []
}

variable "certificate_arn" {
  type    = string
  default = ""
}