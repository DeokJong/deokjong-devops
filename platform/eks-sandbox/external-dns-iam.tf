locals {
  external_dns_instances = {
    private = {
      namespace         = "external-dns"
      service_account   = "external-dns-private"
      domain_filters    = ["jinjin99.xyz"]
      sources           = ["gateway-httproute"]
      gateway_name      = "internal-gateway"
      aws_zone_type     = "private"
      txt_owner_id      = "${local.cluster_name}-private"
      route53_zone_arns = ["arn:aws:route53:::hostedzone/*"]
      policy            = "sync"
      interval          = "1m"
    }
    public = {
      namespace         = "external-dns"
      service_account   = "external-dns-public"
      domain_filters    = ["jinjin99.xyz"]
      sources           = ["gateway-httproute"]
      gateway_name      = "public-gateway"
      aws_zone_type     = "public"
      txt_owner_id      = "${local.cluster_name}-public"
      route53_zone_arns = ["arn:aws:route53:::hostedzone/*"]
      policy            = "sync"
      interval          = "1m"
    }
  }
}

module "external_dns_pod_identity" {
  source  = "terraform-aws-modules/eks-pod-identity/aws"
  version = "2.8.0"

  for_each = local.external_dns_instances

  name            = "${local.cluster_name}-external-dns-${each.key}"
  use_name_prefix = false

  trust_policy_conditions = [
    {
      test     = "StringEquals"
      variable = "aws:RequestTag/kubernetes-namespace"
      values   = [each.value.namespace]
    },
    {
      test     = "StringEquals"
      variable = "aws:RequestTag/kubernetes-service-account"
      values   = [each.value.service_account]
    },
  ]

  attach_external_dns_policy    = true
  external_dns_policy_name      = "${local.cluster_name}-external-dns-${each.key}"
  external_dns_hosted_zone_arns = each.value.route53_zone_arns

  associations = {
    this = {
      cluster_name    = local.cluster_name
      namespace       = each.value.namespace
      service_account = each.value.service_account
    }
  }
}
