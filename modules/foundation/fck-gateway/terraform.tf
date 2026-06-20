terraform {
  required_providers {
    aws = {
      version = "~> 6.0"
    }
  }
}

provider "aws" {
  region = "ap-northeast-2"
}
