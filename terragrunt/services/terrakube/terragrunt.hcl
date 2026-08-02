include "root" {
  path   = find_in_parent_folders("root.hcl")
  expose = true
}

terraform {
  source = "tfr:///terraform-aws-modules/eks-pod-identity/aws?version=2.8.2"
}

dependency "cluster" {
  config_path = "${include.root.locals.platform_path}/eks/cluster"
}

locals {
  namespace       = "terrakube"
  service_account = "terrakube"

  bucket_name = "deokjong-terrakube-storage"
  bucket_arn  = "arn:aws:s3:::${local.bucket_name}"
}

inputs = {
  name            = "terrakube"
  use_name_prefix = false
  description     = "Terrakube API/executor/registry S3 access"

  attach_custom_policy = true
  policy_statements = [
    {
      sid       = "ListBucket"
      effect    = "Allow"
      actions   = ["s3:ListBucket", "s3:GetBucketLocation"]
      resources = [local.bucket_arn]
    },
    {
      sid       = "ObjectAccess"
      effect    = "Allow"
      actions   = ["s3:GetObject", "s3:PutObject", "s3:DeleteObject"]
      resources = ["${local.bucket_arn}/*"]
    },
  ]

  associations = {
    terrakube = {
      cluster_name    = dependency.cluster.outputs.cluster_name
      namespace       = local.namespace
      service_account = local.service_account
    }
  }
}
