module "eks" {
  source  = "terraform-aws-modules/eks/aws"
  version = "~> 21.0"

  name               = var.cluster_name
  kubernetes_version = "1.36"

  compute_config = {
    enabled    = true
    node_pools = ["system"]
  }

  subnet_ids = var.private_subnet_ids

  security_group_additional_rules = {
    ingress_fck_gateway_443 = {
      description              = "Tailscale subnet router to EKS private endpoint"
      protocol                 = "tcp"
      from_port                = 443
      to_port                  = 443
      type                     = "ingress"
      source_security_group_id = var.subnet_router_sg
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

  vpc_id = var.vpc_id
}
