variable "aws_region" {
  type      = string
  sensitive = true
}

variable "bedrock_access_role_arn" {
  type      = string
  sensitive = true
}

variable "allowed_email" {
  type      = string
  sensitive = true
}

variable "principal_email_tag_key" {
  type      = string
  sensitive = true
}

variable "claude_code_role_name" {
  type = string
}

variable "model_invocation_log_retention_days" {
  type = number
}

variable "aws_profile" {
  type      = string
  sensitive = true
}
