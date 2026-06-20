resource "aws_eks_addon" "metrics_server" {
  cluster_name                = var.cluster_name
  addon_name                  = "metrics-server"
  preserve                    = false
  resolve_conflicts_on_create = "OVERWRITE"
  resolve_conflicts_on_update = "OVERWRITE"
}

resource "aws_eks_addon" "cert_manager" {
  cluster_name                = var.cluster_name
  addon_name                  = "cert-manager"
  preserve                    = false
  resolve_conflicts_on_create = "OVERWRITE"
  resolve_conflicts_on_update = "OVERWRITE"
  configuration_values = jsonencode({
    extraArgs = [
      "--dns01-recursive-nameservers-only",
      "--dns01-recursive-nameservers=1.1.1.1:53,8.8.8.8:53",
    ]
  })
}

resource "aws_eks_addon" "external_dns" {
  cluster_name                = var.cluster_name
  addon_name                  = "external-dns"
  preserve                    = false
  resolve_conflicts_on_create = "OVERWRITE"
  resolve_conflicts_on_update = "OVERWRITE"
  configuration_values = jsonencode({
    txtOwnerId   = var.cluster_name
  })

  pod_identity_association {
    role_arn        = module.external_dns_pod_identity.iam_role_arn
    service_account = "external-dns"
  }
}
