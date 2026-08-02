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
}

inputs = {
  name = "${dependency.cluster.outputs.cluster_name}-external-secrets"

  attach_external_secrets_policy      = true
  external_secrets_ssm_parameter_arns = ["arn:aws:ssm:ap-northeast-2:${local.account_id}:parameter:*"]

  associations = {
    this = {
      cluster_name    = dependency.cluster.outputs.cluster_name
      namespace       = "external-secrets"
      service_account = "external-secrets"
    }
  }
}
