# ── EKS Cluster ───────────────────────────────────────────────────────────────

variable "cluster_name" {
  description = "Name of the EKS cluster"
  type        = string
}

# ── DNS ───────────────────────────────────────────────────────────────────────

variable "route53_arns" {
  description = "List of Route53 hosted zone ARNs that external-dns is allowed to manage"
  type        = list(string)
  sensitive   = true
}
