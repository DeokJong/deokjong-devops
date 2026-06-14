module "cert_manager_pod_identity" {
  source  = "terraform-aws-modules/eks-pod-identity/aws"
  version = "~> 2.0"

  name                          = "cert-manager"
  use_name_prefix               = "false"
  attach_cert_manager_policy    = true
  cert_manager_hosted_zone_arns = var.route53_arns

  associations = {
    cert_manager = {
      cluster_name    = var.cluster_name
      namespace       = "cert-manager"
      service_account = "cert-manager"
    }
  }
}

module "external_dns_pod_identity" {
  source  = "terraform-aws-modules/eks-pod-identity/aws"
  version = "~> 2.0"

  name                          = "external_dns"
  use_name_prefix               = "false"
  attach_external_dns_policy    = true
  external_dns_hosted_zone_arns = var.route53_arns
}
