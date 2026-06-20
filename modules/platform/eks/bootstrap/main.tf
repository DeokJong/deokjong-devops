locals {
  node_classes = {
    workload = {
      name                              = "workload"
      node_role_name                    = var.node_iam_role_name
      cluster_primary_security_group_id = var.cluster_primary_security_group_id
    }
  }

  node_pools = {
    default = {
      name      = "default"
      nodeclass = "workload"
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

resource "kubernetes_manifest" "applicationset" {
  manifest = yamldecode(templatefile("${path.module}/manifests/applicationset.yaml.tftpl", {
    cluster_name = var.cluster_name
  }))
}

resource "kubernetes_secret_v1" "cluster" {
  metadata {
    name      = "in-cluster"
    namespace = "argocd"
    labels = {
      "argocd.argoproj.io/secret-type" = "cluster"
    }
  }
  data = {
    name    = "in-cluster"
    server  = var.cluster_arn
    project = "default"
  }

  lifecycle {
    ignore_changes = [metadata[0].annotations]
  }
}
