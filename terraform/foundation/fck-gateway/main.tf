module "fck-gateway" {
  source = "Rajiska/fck-nat/aws"
  name   = "fck-Gateway"

  vpc_id              = local.vpc_id
  subnet_id           = local.public_subnet_ids[0]
  ha_mode             = true
  instance_type       = "t4g.micro"
  use_spot_instances  = true
  update_route_tables = true
  route_tables_ids = {
    for idx, rtb_id in local.private_route_table_ids :
    "private-${idx}" => rtb_id
  }

  cloud_init_parts = [{
    content_type = "text/x-shellscript"
    content = templatefile("${path.module}/tailscale_setup.bash.tftpl", {
      ts_auth_key          = data.aws_ssm_parameter.ts_auth_key.value
      advertise_routes     = [local.vpc_cidr]
      name                 = "tailscale-subnet-router"
      tailscale_extra_args = []
    })
  }]
}
