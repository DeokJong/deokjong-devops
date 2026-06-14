include "root" {
  path   = find_in_parent_folders("root.hcl")
  expose = true
}

terraform {
  source = "${get_repo_root()}//terraform/${path_relative_to_include()}"
}

dependency "fck_gateway" {
  config_path = "${include.root.locals.foundation_path}/fck-gateway"
}

dependency "vpc" {
  config_path = "${include.root.locals.foundation_path}/vpc"
}

inputs = merge({
  private_subnet_ids = dependency.vpc.outputs.private_subnets
  subnet_router_sg   = dependency.fck_gateway.outputs.gateway_security_groups_ids[0]
  vpc_id             = dependency.vpc.outputs.vpc_id
  }, include.root.locals.platform.eks.cluster
)
