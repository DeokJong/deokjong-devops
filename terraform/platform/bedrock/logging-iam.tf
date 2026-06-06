data "aws_iam_policy_document" "bedrock_model_invocation_logging_assume_role" {
  statement {
    sid     = "AllowBedrockToAssumeRole"
    effect  = "Allow"
    actions = ["sts:AssumeRole"]

    principals {
      type        = "Service"
      identifiers = ["bedrock.amazonaws.com"]
    }
  }
}

data "aws_iam_policy_document" "bedrock_model_invocation_logging" {
  statement {
    sid    = "AllowCloudWatchLogsDelivery"
    effect = "Allow"

    actions = [
      "logs:CreateLogStream",
      "logs:PutLogEvents",
    ]

    resources = [
      "${aws_cloudwatch_log_group.bedrock_model_invocations.arn}:log-stream:*",
    ]
  }
}

resource "aws_iam_role" "bedrock_model_invocation_logging" {
  name               = "bedrock-model-invocation-logging"
  assume_role_policy = data.aws_iam_policy_document.bedrock_model_invocation_logging_assume_role.json

  tags = {
    Name      = "bedrock-model-invocation-logging"
    ManagedBy = "terraform"
    Purpose   = "bedrock-model-invocation-logging"
  }
}

resource "aws_iam_policy" "bedrock_model_invocation_logging" {
  name        = "bedrock-model-invocation-logging-policy"
  description = "Allow Amazon Bedrock to deliver model invocation logs to CloudWatch Logs."
  policy      = data.aws_iam_policy_document.bedrock_model_invocation_logging.json
}

resource "aws_iam_role_policy_attachment" "bedrock_model_invocation_logging" {
  role       = aws_iam_role.bedrock_model_invocation_logging.name
  policy_arn = aws_iam_policy.bedrock_model_invocation_logging.arn
}
