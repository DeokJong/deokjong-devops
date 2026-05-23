output "claude_code_bedrock_role_arn" {
  value = aws_iam_role.claude_code_bedrock.arn
}

output "claude_code_environment" {
  sensitive = true

  value = {
    CLAUDE_CODE_USE_BEDROCK = "1"
    AWS_REGION              = var.aws_region
    AWS_PROFILE             = var.aws_profile
  }
}
