terraform {
  required_providers {
    kubernetes = {
      source  = "hashicorp/kubernetes"
      version = "~> 2.0"
    }
  }
}

provider "kubernetes" {
  host                   = var.cluster_endpoint
  cluster_ca_certificate = base64decode(var.cluster_certificate_authority_data)
  token                  = ephemeral.aws_eks_cluster_auth.this.token
}

ephemeral "aws_eks_cluster_auth" "this" {
  name = var.cluster_name
}
