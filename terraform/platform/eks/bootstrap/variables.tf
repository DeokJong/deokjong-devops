variable "cluster_name" {
  type = string
}

variable "cluster_endpoint" {
  type = string
}

variable "cluster_certificate_authority_data" {
  type = string
  sensitive = true
}

variable "node_iam_role_name" {
  type = string
}

variable "node_security_group_id" {
  type = string
}