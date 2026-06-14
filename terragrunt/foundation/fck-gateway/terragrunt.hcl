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

inputs = {
  ts_auth_key_ssm_path = "/foundation/fck-gateway/tailscale_auth_key"
  vpc = {
    vpc_id                  = dependency.vpc.outputs.vpc_id
    vpc_cidr                = dependency.vpc.outputs.vpc_cidr_block
    private_route_table_ids = dependency.vpc.outputs.private_route_table_ids
    public_subnet_ids       = dependency.vpc.outputs.public_subnets
  }
}
