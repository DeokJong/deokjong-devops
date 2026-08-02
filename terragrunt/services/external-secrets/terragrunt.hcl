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
  account_id = include.root.locals.account_id
  region     = "ap-northeast-2"

  secret_arns = [
    "arn:aws:secretsmanager:${local.region}:${local.account_id}:secret:*",
  ]
}

inputs = {
  name            = "${dependency.cluster.outputs.cluster_name}-external-secrets"
  use_name_prefix = false
  description     = "External Secrets Operator access to Secrets Manager"

  attach_external_secrets_policy        = true
  external_secrets_secrets_manager_arns = local.secret_arns
  external_secrets_kms_key_arns         = ["arn:aws:kms:${local.region}:${local.account_id}:key/*"]

  associations = {
    this = {
      cluster_name    = dependency.cluster.outputs.cluster_name
      namespace       = "external-secrets"
      service_account = "external-secrets"
    }
  }
}
