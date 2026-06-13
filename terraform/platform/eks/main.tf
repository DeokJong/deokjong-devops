locals {
  critical_affinity = {
    nodeSelector = {
      "karpenter.sh/nodepool" = "critical"
    }
    tolerations = [
      { key = "CriticalAddonsOnly", operator = "Exists", effect = "NoSchedule" }
    ]
  }
}

module "eks" {
  source  = "terraform-aws-modules/eks/aws"
  version = "~> 21.0"

  name               = var.cluster_name
  kubernetes_version = "1.36"

  compute_config = {
    enabled    = true
    node_pools = ["system"]
  }

  subnet_ids = local.private_subnet_ids

  security_group_additional_rules = {
    ingress_fck_gateway_443 = {
      description              = "Tailscale subnet router to EKS private endpoint"
      protocol                 = "tcp"
      from_port                = 443
      to_port                  = 443
      type                     = "ingress"
      source_security_group_id = local.gateway_sg
    }
  }

  access_entries = {
    admin = {
      principal_arn = "arn:aws:iam::116981803095:role/aws-reserved/sso.amazonaws.com/ap-northeast-2/AWSReservedSSO_AdministratorAccess_41903a724b9f2a5e"
      policy_associations = {
        admin = {
          policy_arn = "arn:aws:eks::aws:cluster-access-policy/AmazonEKSClusterAdminPolicy"
          access_scope = {
            type = "cluster"
          }
        }
      }
    }
  }

  vpc_id = local.vpc_id

  addons = {
    metrics-server = {
      preserve                    = false
      resolve_conflicts_on_create = "OVERWRITE"
      resolve_conflicts_on_update = "OVERWRITE"
      configuration_values = jsonencode({
        tolerations  = local.critical_affinity.tolerations
        nodeSelector = local.critical_affinity.nodeSelector
      })
    }
    cert-manager = {
      preserve                    = false
      resolve_conflicts_on_create = "OVERWRITE"
      resolve_conflicts_on_update = "OVERWRITE"
      configuration_values = jsonencode({
        tolerations  = local.critical_affinity.tolerations
        nodeSelector = local.critical_affinity.nodeSelector
        extraArgs = [
          "--dns01-recursive-nameservers-only",
          "--dns01-recursive-nameservers=1.1.1.1:53,8.8.8.8:53",
        ]
      })
      service_account_role_arn = module.cert_manager_irsa.arn
    }
    external-dns = {
      preserve                    = false
      resolve_conflicts_on_create = "OVERWRITE"
      resolve_conflicts_on_update = "OVERWRITE"
      configuration_values = jsonencode({
        tolerations  = local.critical_affinity.tolerations
        nodeSelector = local.critical_affinity.nodeSelector
        txtOwnerId   = var.cluster_name
      })
      pod_identity_association = [{
        role_arn        = module.external_dns_pod_identity.iam_role_arn
        service_account = "external-dns"
      }]
    }
  }
}
