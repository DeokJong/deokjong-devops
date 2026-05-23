data "terraform_remote_state" "foundation_vpc" {
  backend = "s3"

  config = {
    bucket       = var.remote_state_bucket
    region       = var.remote_state_region
    key          = var.foundation_vpc_state_key
    use_lockfile = true
  }
}

data "aws_ssm_parameter" "ts_auth_key" {
  name            = "/foundation/fck-gateway/tailscale_auth_key"
  with_decryption = true
}

locals {
  vpc_id                  = data.terraform_remote_state.foundation_vpc.outputs.vpc.id
  vpc_cidr                = data.terraform_remote_state.foundation_vpc.outputs.vpc.cidr_block
  private_route_table_ids = data.terraform_remote_state.foundation_vpc.outputs.vpc.private_route_table_ids
  public_subnet_ids       = data.terraform_remote_state.foundation_vpc.outputs.vpc.public_subnet_ids
}
