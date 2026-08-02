terraform {
  required_version = ">= 1.1.0"

  cloud {
    hostname     = "terrakube-api.jinops.cloud"
    organization = "sandbox"

    workspaces {
      name = "deokjong-devops"
    }
  }
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 6.36"
    }
  }
}

resource "terraform_data" "test" {
  input = "Hello Terrakube"
}

resource "terraform_data" "test2" {
  input = "Hello Terrakube"
}

output "message" {
  value = terraform_data.test.output
}
