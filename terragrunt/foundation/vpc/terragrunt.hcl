include "root" {
  path = find_in_parent_folders("root.hcl")
}

terraform {
  source = "tfr:///terraform-aws-modules/vpc/aws?version=6.6.1"
}

inputs = {
  name = "deokjong"
  cidr = "10.0.0.0/16"

  azs             = ["ap-northeast-2a", "ap-northeast-2b", "ap-northeast-2c"]
  public_subnets  = ["10.0.0.0/20", "10.0.16.0/20", "10.0.32.0/20"]
  private_subnets = ["10.0.128.0/20", "10.0.144.0/20", "10.0.160.0/20"]

  enable_ipv6                  = true
  public_subnet_ipv6_prefixes  = ["0", "1", "2"]
  private_subnet_ipv6_prefixes = ["3", "4", "5"]

  public_subnet_enable_dns64                                    = false
  public_subnet_enable_resource_name_dns_aaaa_record_on_launch = false
  private_subnet_enable_dns64                                   = false
  private_subnet_enable_resource_name_dns_aaaa_record_on_launch = false

  public_subnet_suffix  = "rtb-public"
  private_subnet_suffix = "rtb-private"

  public_subnet_names = [
    "deokjong-subnet-public1-ap-northeast-2a",
    "deokjong-subnet-public2-ap-northeast-2b",
    "deokjong-subnet-public3-ap-northeast-2c",
  ]

  private_subnet_names = [
    "deokjong-subnet-private1-ap-northeast-2a",
    "deokjong-subnet-private2-ap-northeast-2b",
    "deokjong-subnet-private3-ap-northeast-2c",
  ]

  vpc_tags = {
    Name = "deokjong-vpc"
  }

  igw_tags = {
    Name = "deokjong-igw"
  }

  private_subnet_tags = {
    "karpenter.sh/discovery/private"  = "-"
    "kubernetes.io/role/internal-elb" = "1"
  }

  public_subnet_tags = {
    "karpenter.sh/discovery/public" = "-"
    "kubernetes.io/role/elb"        = "1"
  }

  manage_default_network_acl    = false
  manage_default_route_table    = false
  manage_default_security_group = false
}
