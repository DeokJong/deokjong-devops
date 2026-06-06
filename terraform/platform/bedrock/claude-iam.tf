data "aws_caller_identity" "current" {}

data "aws_partition" "current" {}

data "aws_iam_policy_document" "claude_code_assume_role" {
  statement {
    sid     = "AllowBedrockAccessRoleWithEmailAndMfa"
    effect  = "Allow"
    actions = ["sts:AssumeRole"]

    principals {
      type        = "AWS"
      identifiers = [var.bedrock_access_role_arn]
    }

    condition {
      test     = "StringEquals"
      variable = "aws:PrincipalTag/${var.principal_email_tag_key}"
      values   = [var.allowed_email]
    }

    condition {
      test     = "Bool"
      variable = "aws:MultiFactorAuthPresent"
      values   = ["true"]
    }
  }
}

data "aws_iam_policy_document" "claude_code_bedrock" {
  statement {
    sid    = "AllowBedrockModelInvocation"
    effect = "Allow"

    actions = [
      "bedrock:GetFoundationModel",
      "bedrock:GetInferenceProfile",
      "bedrock:GetProvisionedModelThroughput",
      "bedrock:InvokeModel",
      "bedrock:InvokeModelWithResponseStream",
    ]

    resources = ["*"]
  }

  statement {
    sid    = "AllowBedrockModelDiscovery"
    effect = "Allow"

    actions = [
      "bedrock:ListFoundationModels",
      "bedrock:ListInferenceProfiles",
    ]

    resources = ["*"]
  }

  statement {
    sid    = "AllowBedrockModelAccessUseCaseSubmission"
    effect = "Allow"

    actions = [
      "bedrock:PutUseCaseForModelAccess",
    ]

    resources = ["*"]
  }

  statement {
    sid    = "AllowMarketplaceSubscriptionThroughBedrock"
    effect = "Allow"

    actions = [
      "aws-marketplace:Subscribe",
      "aws-marketplace:ViewSubscriptions",
    ]

    resources = ["*"]

    condition {
      test     = "StringEquals"
      variable = "aws:CalledViaLast"
      values   = ["bedrock.amazonaws.com"]
    }
  }
}
