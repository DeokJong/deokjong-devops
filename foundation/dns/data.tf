data "terraform_remote_state" "foundation_vpc" {
  backend = "s3"

  config = {
    bucket       = var.remote_state_bucket
    region       = var.remote_state_region
    key          = var.foundation_vpc_state_key
    use_lockfile = true
  }
}

locals {
  vpc_id = data.terraform_remote_state.foundation_vpc.outputs.vpc.id
}
