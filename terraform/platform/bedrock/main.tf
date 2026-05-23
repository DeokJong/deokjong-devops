resource "aws_iam_role" "claude_code_bedrock" {
  name               = var.claude_code_role_name
  assume_role_policy = data.aws_iam_policy_document.claude_code_assume_role.json

  tags = {
    Name      = var.claude_code_role_name
    ManagedBy = "terraform"
    Purpose   = "claude-code-bedrock"
  }
}

resource "aws_iam_policy" "claude_code_bedrock" {
  name        = "${var.claude_code_role_name}-policy"
  description = "Claude Code access to Anthropic Claude models through Amazon Bedrock."
  policy      = data.aws_iam_policy_document.claude_code_bedrock.json
}

resource "aws_iam_role_policy_attachment" "claude_code_bedrock" {
  role       = aws_iam_role.claude_code_bedrock.name
  policy_arn = aws_iam_policy.claude_code_bedrock.arn
}

resource "aws_cloudwatch_log_group" "bedrock_model_invocations" {
  name              = "/aws/bedrock/claude-code/model-invocations"
  retention_in_days = var.model_invocation_log_retention_days
}

resource "aws_bedrock_model_invocation_logging_configuration" "claude_code" {
  logging_config {
    cloudwatch_config {
      log_group_name = aws_cloudwatch_log_group.bedrock_model_invocations.name
      role_arn       = aws_iam_role.bedrock_model_invocation_logging.arn
    }

    embedding_data_delivery_enabled = false
    image_data_delivery_enabled     = false
    text_data_delivery_enabled      = true
  }
}
