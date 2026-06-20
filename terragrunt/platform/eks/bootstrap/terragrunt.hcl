include "root" {
  path   = find_in_parent_folders("root.hcl")
  expose = true
}

terraform {
  source = "${get_repo_root()}//modules/${path_relative_to_include()}"
}

dependency "cluster" {
  config_path = "${include.root.locals.platform_path}/eks/cluster"
}

inputs = merge(dependency.cluster.outputs)
