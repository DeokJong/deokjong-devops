variable "cluster_name" {
  type = string
}

variable "oidc_provider_arn" {
  type = string
}

variable "route53_arns" {
  type      = list(string)
  sensitive = true
}
