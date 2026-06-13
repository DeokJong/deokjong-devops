locals {
  node_classes = {
    default = {
      name                   = "default-class"
      node_role_name         = module.sandbox.node_iam_role_name
      node_security_group_id = module.sandbox.node_security_group_id
    }
  }

  node_pools = {
    system = {
      name      = "critical"
      nodeclass = "default-class"
      taints    = [{ key = "CriticalAddonsOnly", effect = "NoSchedule", value = "" }]
    }
    general-purpose = {
      name      = "workload"
      nodeclass = "default-class"
      taints    = []
    }
  }
}

resource "kubernetes_manifest" "node_classes" {
  for_each = local.node_classes
  manifest = yamldecode(templatefile("${path.module}/manifests/nodeclasses.yaml.tftpl", each.value))
}

resource "kubernetes_manifest" "node_pools" {
  for_each = local.node_pools
  manifest = yamldecode(templatefile("${path.module}/manifests/nodepools.yaml.tftpl", each.value))
}
