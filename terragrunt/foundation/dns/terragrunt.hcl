include "root" {
  path = find_in_parent_folders("root.hcl")
}

terraform {
  source = "tfr:///terraform-aws-modules/route53/aws//modules/zones?version=5.0.0"
}

inputs = {
  zones = {
    "jinjin99.xyz" = {
      comment = ""
      tags = {
        Name = "jinjin99.xyz"
      }
    }
  }
}
