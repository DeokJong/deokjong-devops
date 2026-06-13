variable "vpc" {
  type = object({
    vpc_id                  = string
    vpc_cidr                = list(string)
    private_route_table_ids = list(string)
    public_subnet_ids       = list(string)
  })
}

variable "ts_auth_key_ssm_path" {
  type      = string
  sensitive = true
}
