# ── EKS Cluster ───────────────────────────────────────────────────────────────

variable "cluster_name" {
  description = "Name of the EKS cluster"
  type        = string
}

# ── IAM / IRSA ────────────────────────────────────────────────────────────────

variable "oidc_provider_arn" {
  description = "ARN of the EKS OIDC provider for IRSA (IAM Roles for Service Accounts)"
  type        = string
}

# ── DNS ───────────────────────────────────────────────────────────────────────

variable "route53_arns" {
  description = "List of Route53 hosted zone ARNs that external-dns is allowed to manage"
  type        = list(string)
  sensitive   = true
}
