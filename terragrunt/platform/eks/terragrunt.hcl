include "root" {
  path   = find_in_parent_folders("root.hcl")
  expose = true
}

terraform {
  source = "${get_repo_root()}//terraform/${path_relative_to_include()}"
}

dependency "vpc" {
  config_path = "${include.root.locals.foundation_path}/vpc"
}

dependency "fck_gateway" {
  config_path = "${include.root.locals.foundation_path}/fck-gateway"
}

inputs = {
  cluster_name = "deokjong-sandbox"
  route53_arns = [
    "arn:aws:route53:::hostedzone/Z05211163C63AOHWJ4F1W"
  ]
  subnet_router_sg   = dependency.fck_gateway.outputs.gateway_security_groups_ids[0]
  vpc_id             = dependency.vpc.outputs.vpc_id
  private_subnet_ids = dependency.vpc.outputs.private_subnets
}