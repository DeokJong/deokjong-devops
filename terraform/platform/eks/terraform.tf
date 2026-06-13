terraform {
  backend "s3" {}

  required_providers {
    aws = {
      version = "~> 6.0"
    }
    kubernetes = {
      source  = "hashicorp/kubernetes"
      version = "~> 2.0"
    }
  }
}

provider "aws" {
  region = "ap-northeast-2"
}

provider "kubernetes" {
  host                   = module.eks.cluster_endpoint
  cluster_ca_certificate = base64decode(module.eks.cluster_certificate_authority_data)
  token                  = ephemeral.aws_eks_cluster_auth.this.token
}

ephemeral "aws_eks_cluster_auth" "this" {
  name = module.eks.cluster_name
}
