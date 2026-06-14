variable "cluster_name" {
  type = string
}

variable "subnet_router_sg" {
  type = string
}

variable "vpc_id" {
  type = string
}

variable "private_subnet_ids" {
  type = list(string)
}

variable "idc_instance_arn" {
  type = string
  sensitive = true
}

variable "admin_principal_arn" {
  type = string
  sensitive = true
}

variable "admin_sso_group_id" {
  type = string
  sensitive = true
}
