module "argocd_capability" {
  source = "terraform-aws-modules/eks/aws//modules/capability"

  name         = "argocd"
  cluster_name = var.cluster_name
  type         = "ARGOCD"

  configuration = {
    argo_cd = {
      aws_idc = {
        idc_instance_arn = var.idc_instance_arn
      }
      namespace = "argocd"
      rbac_role_mapping = [{
        role = "ADMIN"
        identity = [{
          id   = var.admin_sso_group_id
          type = "SSO_GROUP"
        }]
      }]
    }
  }
}
