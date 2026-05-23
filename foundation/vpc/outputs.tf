output "vpc" {
  description = "VPC information for remote state consumers."
  value = {
    name            = "deokjong"
    id              = module.deokjong_vpc.vpc_id
    cidr_block      = module.deokjong_vpc.vpc_cidr_block
    ipv6_cidr_block = module.deokjong_vpc.vpc_ipv6_cidr_block

    azs = module.deokjong_vpc.azs

    public_subnet_ids          = module.deokjong_vpc.public_subnets
    private_subnet_ids         = module.deokjong_vpc.private_subnets
    public_subnet_cidr_blocks  = module.deokjong_vpc.public_subnets_cidr_blocks
    private_subnet_cidr_blocks = module.deokjong_vpc.private_subnets_cidr_blocks
    public_route_table_ids     = module.deokjong_vpc.public_route_table_ids
    private_route_table_ids    = module.deokjong_vpc.private_route_table_ids
    internet_gateway_id        = module.deokjong_vpc.igw_id
    default_security_group_id  = module.deokjong_vpc.default_security_group_id
  }
}