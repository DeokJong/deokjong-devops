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

inputs = {
  cluster_certificate_authority_data = dependency.cluster.outputs.cluster_certificate_authority_data
  cluster_endpoint                   = dependency.cluster.outputs.cluster_endpoint
  cluster_name                       = dependency.cluster.outputs.cluster_name
  node_iam_role_name                 = dependency.cluster.outputs.node_iam_role_name
  node_security_group_id             = dependency.cluster.outputs.node_security_group_id
}
