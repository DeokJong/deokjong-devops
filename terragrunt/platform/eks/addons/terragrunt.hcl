include "root" {
  path   = find_in_parent_folders("root.hcl")
  expose = true
}

terraform {
  source = "${get_repo_root()}//terraform/${path_relative_to_include()}"
}

dependency "cluster" {
  config_path = "${include.root.locals.platform_path}/eks/cluster"
}

dependency "dns" {
  config_path = "${include.root.locals.foundation_path}/dns"
}

inputs = {
  cluster_name      = dependency.cluster.outputs.cluster_name
  oidc_provider_arn = dependency.cluster.outputs.oidc_provider_arn
  route53_arns      = values(dependency.dns.outputs.route53_zone_zone_arn)
}
