locals {
  node_classes = {
    default = {
      name                   = "default-class"
      node_role_name         = var.node_iam_role_name
      node_security_group_id = var.node_security_group_id
    }
  }

  node_pools = {
    critical = {
      name      = "critical"
      nodeclass = "default-class"
      taints    = [{ key = "CriticalAddonsOnly", effect = "NoSchedule", value = "" }]
    }
    workload = {
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

resource "kubernetes_manifest" "root_application" {
  manifest = yamldecode(templatefile("${path.module}/manifests/root-application.yaml.tftpl", {
    cluster_name = var.cluster_name
  }))
}

resource "kubernetes_secret_v1" "cluster" {
  metadata {
    name      = var.cluster_name
    namespace = "argpcd"
    labels = {
      "argocd.argoproj.io/secret-type" = "cluster"
    }

    data = {
      name    = var.cluster_name
      server  = var.cluster_endpoint
      project = "default"
    }
  }
}
