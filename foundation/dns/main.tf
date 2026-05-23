terraform {
  backend "s3" {}

  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 6.0"
    }
    tailscale = {
      source  = "tailscale/tailscale"
      version = "~> 0.0"
    }
  }
}

provider "aws" {
  region = "ap-northeast-2"
}

provider "tailscale" {
  api_key = var.tailscale.api_key
  tailnet = var.tailscale.tailnet
}

module "internal_dns" {
  for_each    = toset(var.dns_list)
  source      = "DeokJong/private-dns-tailscale/aws"
  vpc_id      = local.vpc_id
  domain_name = each.key
}
