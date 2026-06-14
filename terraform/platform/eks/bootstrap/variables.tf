# ── EKS Cluster ───────────────────────────────────────────────────────────────
variable "cluster_arn" {
  description = "arn of the EKS cluster"
  type        = string
}

variable "cluster_certificate_authority_data" {
  description = "Base64-encoded certificate authority data for authenticating to the EKS cluster"
  type        = string
  sensitive   = true
}

variable "cluster_endpoint" {
  description = "HTTPS endpoint URL of the EKS cluster API server"
  type        = string
}

variable "cluster_name" {
  description = "Name of the EKS cluster"
  type        = string
}

# ── Node ──────────────────────────────────────────────────────────────────────

variable "node_iam_role_name" {
  description = "Name of the IAM role attached to EKS worker nodes"
  type        = string
}

variable "node_security_group_id" {
  description = "Security group ID attached to the EKS worker nodes"
  type        = string
}
