# ── EKS Cluster ───────────────────────────────────────────────────────────────

variable "cluster_name" {
  description = "Name of the EKS cluster"
  type        = string
}

# ── IAM Identity Center ───────────────────────────────────────────────────────

variable "admin_principal_arn" {
  description = "ARN of the IAM principal to grant EKS cluster admin access via AWS IAM Identity Center"
  type        = string
  sensitive   = true
}

variable "admin_sso_group_id" {
  description = "ID of the AWS IAM Identity Center SSO group to grant EKS cluster admin access"
  type        = string
  sensitive   = true
}

variable "idc_instance_arn" {
  description = "ARN of the AWS IAM Identity Center instance used for SSO access management"
  type        = string
  sensitive   = true
}

# ── Network ───────────────────────────────────────────────────────────────────

variable "private_subnet_ids" {
  description = "List of private subnet IDs in which EKS worker nodes are launched"
  type        = list(string)
}

variable "subnet_router_sg" {
  description = "Security group ID of the fck-nat gateway instance used as the subnet router"
  type        = string
}

variable "vpc_id" {
  description = "ID of the VPC in which the EKS cluster is deployed"
  type        = string
}
