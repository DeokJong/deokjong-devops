data "terraform_remote_state" "foundation_vpc" {
  backend = "s3"

  config = {
    bucket       = var.remote_state_bucket
    region       = var.remote_state_region
    key          = var.foundation_vpc_state_key
    use_lockfile = true
  }
}

data "terraform_remote_state" "foundation_fck_gateway" {
  backend = "s3"

  config = {
    bucket       = var.remote_state_bucket
    region       = var.remote_state_region
    key          = var.foundation_fck_gateway_state_key
    use_lockfile = true
  }
}

locals {
  gateway_sg         = data.terraform_remote_state.foundation_fck_gateway.outputs.gateway_security_groups_ids[0]
  vpc_id             = data.terraform_remote_state.foundation_vpc.outputs.vpc.id
  private_subnet_ids = data.terraform_remote_state.foundation_vpc.outputs.vpc.private_subnet_ids
}
